import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:pici_nft/core/presentation/nft_exception.dart';
import 'package:web3_storage/web3_storage.dart';

import '../../config/web3storage_config.dart';

class Web3StorageSource {
  Future<String> uploadImage({File? imageFile}) async {
    var imageCID;
    final web3Storage = withApiToken(apiToken);

    final file = RawFile(
      name: "PiciNFT #2",
      extension: 'jpg',
      data: imageFile!.readAsBytesSync(),
    );

    final result = await web3Storage.upload(file: file);

    result.fold((l) => l.stackTrace, (r) => imageCID = r.cid);
    print('https://w3s.link/ipfs/$imageCID');
    return 'https://w3s.link/ipfs/$imageCID';
  }

  Future<String> uploadData({String? jsonData}) async {
    var dataCID;
    final web3Storage = withApiToken(apiToken);

    final file = RawFile(
      name: "PiciNFT #1 Data",
      extension: 'json',
      data: Uint8List.fromList(utf8.encode(json.encode(jsonData!))),
      // data: json.decode(dataCID),
    );

    final result = await web3Storage.upload(file: file);

    result.fold((l) => l.stackTrace, (r) => dataCID = r.cid);

    print('https://w3s.link/ipfs/$dataCID');
    return 'https://w3s.link/ipfs/$dataCID';
  }
}
