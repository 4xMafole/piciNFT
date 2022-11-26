import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phantom_connect/src/phantom_connect.dart';
import 'package:pinenacl/api.dart';
import 'package:uni_links/uni_links.dart';

import 'package:url_launcher/url_launcher.dart';

// ignore: depend_on_referenced_packages
import 'package:solana/dto.dart';
// ignore: depend_on_referenced_packages
import 'package:solana/solana.dart';

import '../../../../core/presentation/nft_exception.dart';
import '../../../../core/utils/app_strings.dart';
import '../../data/repository/phantom_wallet_repository.dart';
import '../../domain/metadata_NFT.dart';

@immutable
abstract class PhantomWalletState {}

class PhantomWalletInitial extends PhantomWalletState {}

class PhantomWalletInProgress extends PhantomWalletState {}

class PhantomWalletSuccess extends PhantomWalletState {
  final String data;
  PhantomWalletSuccess(this.data);
}

class PhantomWalletFailure extends PhantomWalletState {
  final String errorMessage;
  PhantomWalletFailure(this.errorMessage);
}

class PhantomWalletConnection extends PhantomWalletState {
  final bool isConnected;
  PhantomWalletConnection(this.isConnected);
}

class PhantomWalletConnected extends PhantomWalletState {
  final String message;

  PhantomWalletConnected(this.message);
}

class PhantomWalletSignAndSendTransaction extends PhantomWalletState {
  final Map<dynamic, dynamic>? data;
  final int signCounter;
  PhantomWalletSignAndSendTransaction(this.data, this.signCounter);
}

class PhantomWalletCubit extends Cubit<PhantomWalletState> {
  final PhantomWalletRepository _repository;
  late StreamSubscription _sub;
  late PhantomConnect _phantomConnect;
  late int _signCounter;

  late String tokenPublicKey;

  late MetadataNFT nftData;

  PhantomWalletCubit(this._repository) : super(PhantomWalletInitial()) {
    _phantomConnect = PhantomConnect(
      appUrl: AppStrings.solanaAppUrl,
      deepLink: AppStrings.phantomDeepLink,
    );
    _signCounter = 0;
    if (!kIsWeb) {
      handleIncomingLinks();
    }
  }

  void updateConnection(bool value) => emit(PhantomWalletConnection(value));

  void handleIncomingLinks() {
    try {
      _sub = uriLinkStream.listen((Uri? link) {
        Map<String, String> params = link?.queryParameters ?? {};
        if (kDebugMode) {
          print("Params: $params");
        }

        if (params.containsKey("errorCode")) {
          emit(PhantomWalletFailure(
              params["errorMessage"] ?? "Error connecting wallet"));

          if (kDebugMode) {
            print(params["errorMessage"]);
          }
        } else {
          switch (link?.path) {
            case '/${AppStrings.connectedLink}':
              if (_phantomConnect.createSession(params)) {
                emit(PhantomWalletConnection(true));
                emit(PhantomWalletSuccess("connected"));

                emit(PhantomWalletConnected("Connected to Wallet"));
              } else {
                emit(PhantomWalletFailure(
                    params["errorMessage"] ?? "Error connecting wallet"));
              }
              break;
            case '/${AppStrings.signAndSendTransactionLink}':
              var data = _phantomConnect.decryptPayload(
                  data: params["data"]!, nonce: params["nonce"]!);

              _signCounter++;

              if (_signCounter == 1) {
                _createAssociateAccount();
              } else if (_signCounter == 2) {
                _createNFT();
              } else if (_signCounter == 3) {
                _createMetadataAccount();
              } else if (_signCounter == 4) {
                _removeMintAuthority();
                emit(PhantomWalletSuccess("NFT Minted Successfully!"));
              }

              emit(PhantomWalletSignAndSendTransaction(data, _signCounter));

              break;
            default:
              emit(PhantomWalletFailure(
                  params["errorMessage"] ?? "Unknown Redirect"));
          }
        }
      }, onError: (err) {
        throw NFTManagementException(errorMessageCode: err.toString());
      });
    } on PlatformException {
      throw NFTManagementException(
          errorMessageCode: "Error occurred PlatformException");
    }
  }

  connectWallet() async {
    emit(PhantomWalletInProgress());

    _repository.connectWallet(_phantomConnect);
  }

  mintingNFT(MetadataNFT metadataNFT) async {
    emit(PhantomWalletInProgress());

    final tokenKey = await _repository.mintingNFT(_phantomConnect);
    tokenPublicKey = tokenKey;
    nftData = metadataNFT;
  }

  _createAssociateAccount() async {
    await _repository.createAssociateAccount(_phantomConnect, tokenPublicKey);
  }

  _createNFT() async {
    await _repository.createNFT(_phantomConnect, tokenPublicKey);
  }

  _createMetadataAccount() async {
    await _repository.createMetadataAccount(
        _phantomConnect, nftData, tokenPublicKey);
  }

  _removeMintAuthority() async {
    await _repository.removeMintAuthority(_phantomConnect, tokenPublicKey);
  }

  void clear() {
    _signCounter = 0;
    emit(PhantomWalletSignAndSendTransaction(null, _signCounter));
  }
}
