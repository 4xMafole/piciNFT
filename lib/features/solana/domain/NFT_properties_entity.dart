import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'NFT_creator_entity.dart';
import 'NFT_entity.dart';
import 'NFT_file_entity.dart';

class NFTPropertiesEntity {
  List<NFTCreatorEntity>? creators;
  List<NFTFileEntity>? files;
  NFTPropertiesEntity({
    this.creators,
    this.files,
  });

  NFTPropertiesEntity copyWith({
    List<NFTCreatorEntity>? creators,
    List<NFTFileEntity>? files,
  }) {
    return NFTPropertiesEntity(
      creators: creators ?? this.creators,
      files: files ?? this.files,
    );
  }

  NFTPropertiesEntity merge(NFTPropertiesEntity model) {
    return NFTPropertiesEntity(
      creators: model.creators ?? this.creators,
      files: model.files ?? this.files,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'creators': creators?.map((x) => x.toMap()).toList(),
      'files': files?.map((x) => x.toMap()).toList(),
    };
  }

  factory NFTPropertiesEntity.fromMap(Map<String, dynamic> map) {
    return NFTPropertiesEntity(
      creators: List<NFTCreatorEntity>.from(
          map['creators']?.map((x) => NFTCreatorEntity?.fromMap(x))),
      files: List<NFTFileEntity>.from(
          map['files']?.map((x) => NFTFileEntity?.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory NFTPropertiesEntity.fromJson(String source) =>
      NFTPropertiesEntity.fromMap(json.decode(source));

  @override
  String toString() =>
      'NFTPropertiesEntity(creators: $creators, files: $files)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is NFTPropertiesEntity &&
        listEquals(o.creators, creators) &&
        listEquals(o.files, files);
  }

  @override
  int get hashCode => creators.hashCode ^ files.hashCode;
}
