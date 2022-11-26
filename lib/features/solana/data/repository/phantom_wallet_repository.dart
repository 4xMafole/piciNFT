// ignore: implementation_imports
import 'package:phantom_connect/src/phantom_connect.dart';

import '../../../../core/presentation/nft_exception.dart';
import '../../domain/metadata_NFT.dart';
import '../data_source/phantom_wallet_source.dart';

class PhantomWalletRepository {
  static final PhantomWalletRepository _phantomWalletRepository =
      PhantomWalletRepository._internal();
  late PhantomWalletSource _phantomWalletSource;

  factory PhantomWalletRepository() {
    _phantomWalletRepository._phantomWalletSource = PhantomWalletSource();
    return _phantomWalletRepository;
  }
  PhantomWalletRepository._internal();

  void connectWallet(PhantomConnect phantomConnectInstance) async {
    try {
      await _phantomWalletSource.connectWallet(phantomConnectInstance);
    } catch (e) {
      throw NFTManagementException(errorMessageCode: e.toString());
    }
  }

  Future<String> mintingNFT(PhantomConnect phantomConnectInstance) async {
    try {
      final tokenKey =
          await _phantomWalletSource.createToken(phantomConnectInstance);
      return tokenKey;
    } catch (e) {
      throw NFTManagementException(errorMessageCode: e.toString());
    }
  }

  Future<void> createAssociateAccount(
      PhantomConnect phantomConnectInstance, String tokenPublicKey) async {
    try {
      await _phantomWalletSource.associatedAccount(
          phantomConnectInstance, tokenPublicKey);
    } catch (e) {
      throw NFTManagementException(errorMessageCode: e.toString());
    }
  }

  createNFT(
      PhantomConnect phantomConnectInstance, String tokenPublicKey) async {
    try {
      await _phantomWalletSource.createNFT(
          phantomConnectInstance, tokenPublicKey);
    } catch (e) {
      throw NFTManagementException(errorMessageCode: e.toString());
    }
  }

  createMetadataAccount(PhantomConnect phantomConnect, MetadataNFT nftData,
      String tokenPublicKey) async {
    try {
      await _phantomWalletSource.metadataAccount(
          nftData, phantomConnect, tokenPublicKey);
    } catch (e) {
      throw NFTManagementException(errorMessageCode: e.toString());
    }
  }

  removeMintAuthority(
      PhantomConnect phantomConnect, String tokenPublicKey) async {
    try {
      await _phantomWalletSource.removeAuthority(
          phantomConnect, tokenPublicKey);
    } catch (e) {
      throw NFTManagementException(errorMessageCode: e.toString());
    }
  }
}
