import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pici_nft/features/solana/data/repository/web3storage_repository.dart';
import 'package:pici_nft/features/solana/domain/NFT_entity.dart';
import 'package:file_picker/file_picker.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../domain/NFT_attribute_entity.dart';

@immutable
abstract class Web3StorageState {}

class Web3StorageInitial extends Web3StorageState {}

class Web3StorageInProgress extends Web3StorageState {}

class Web3StorageDataInProgress extends Web3StorageState {}

class Web3StorageImageSuccess extends Web3StorageState {
  final String data;
  Web3StorageImageSuccess(this.data);
}

class Web3StorageDataSuccess extends Web3StorageState {
  final String data;
  Web3StorageDataSuccess(this.data);
}

class Web3StorageFailure extends Web3StorageState {
  final String message;
  Web3StorageFailure(this.message);
}

class Web3StorageCubit extends Cubit<Web3StorageState> {
  final Web3StorageRepository _repository;
  NFTEntity? data;

  Web3StorageCubit(this._repository) : super(Web3StorageInitial());

  void uploadImage({File? image}) async {
    emit(Web3StorageInProgress());
    _repository
        .uploadImage(image)
        .then((value) => emit(Web3StorageImageSuccess(value)))
        .catchError((e) => emit(Web3StorageFailure(e.toString())));
  }

  void uploadData(
      {required String image,
      required String name,
      required String description,
      required List<NFTAttributeEntity> attributes}) {
    emit(Web3StorageDataInProgress());

    data = NFTEntity(
      name: name,
      description: description,
      image: image,
      attributes: attributes,
    );

    _repository.uploadData(data!).then((dataUrl) {
      emit(Web3StorageDataSuccess(dataUrl));
    }).catchError((e) {
      emit(Web3StorageFailure(e.toString()));
    });
  }

  Future<void> getImageFromGallery() async {
    if (await _permissionToPickImage()) {
      final pickedFile = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.image);

      uploadImage(image: File(pickedFile!.files.first.path!));
    }
  }

  Future<bool> _permissionToPickImage() async {
    bool permissionGranted = await Permission.storage.isGranted;
    if (!permissionGranted) {
      permissionGranted = (await Permission.storage.request()).isGranted;

      return permissionGranted;
    }

    return permissionGranted;
  }
}
