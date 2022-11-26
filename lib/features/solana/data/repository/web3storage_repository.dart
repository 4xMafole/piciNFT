import 'dart:io';

import 'package:pici_nft/features/solana/data/data_source/web3storage_source.dart';
import 'package:pici_nft/features/solana/domain/NFT_entity.dart';

import '../../../../core/presentation/nft_exception.dart';

class Web3StorageRepository {
  static final Web3StorageRepository _repository =
      Web3StorageRepository._internal();
  Web3StorageRepository._internal();
  late Web3StorageSource _source;

  factory Web3StorageRepository() {
    _repository._source = Web3StorageSource();
    return _repository;
  }

  Future<String> uploadImage(File? image) async {
    try {
      final imageCID = await _source.uploadImage(imageFile: image);
      return imageCID;
    } catch (e) {
      throw NFTManagementException(errorMessageCode: e.toString());
    }
  }

  Future<String> uploadData(NFTEntity data) async {
    try {
      final dataCID = await _source.uploadData(jsonData: data.toJson());
      return dataCID;
    } catch (e) {
      throw NFTManagementException(errorMessageCode: e.toString());
    }
  }
}
