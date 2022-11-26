import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'NFT_attribute_entity.dart';
import 'NFT_collection.dart';
import 'NFT_properties_entity.dart';


class NFTEntity {
  String name;
  String description;
  String image;
  double? sellerFeeBasisPoints;
  String? externalUrl;
  List<NFTAttributeEntity> attributes;
  NFTPropertiesEntity? properties;
  NFTCollection? collection;

  NFTEntity({
    required this.name,
    required this.description,
    required this.image,
    this.sellerFeeBasisPoints,
    this.externalUrl,
    required this.attributes,
    this.properties,
    this.collection,
  });

  NFTEntity merge(NFTEntity model) {
    return NFTEntity(
      name: model.name,
      description: model.description,
      image: model.image,
      sellerFeeBasisPoints: model.sellerFeeBasisPoints ?? sellerFeeBasisPoints,
      externalUrl: model.externalUrl ?? externalUrl,
      attributes: model.attributes,
      properties: model.properties ?? properties,
      collection: model.collection ?? collection,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'seller_fee_basis_points': sellerFeeBasisPoints,
      'external_url': externalUrl,
      'attributes': attributes.map((x) => x.toMap()).toList(),
      'properties': properties?.toMap(),
      'collection': collection?.toMap(),
    };
  }

  factory NFTEntity.fromMap(Map<String, dynamic> map) {
    return NFTEntity(
      name: map['name'],
      description: map['description'],
      image: map['image'],
      sellerFeeBasisPoints: map['seller_fee_basis_points'],
      externalUrl: map['external_url'],
      attributes: List<NFTAttributeEntity>.from(
          map['attributes']?.map((x) => NFTAttributeEntity.fromMap(x))),
      properties: NFTPropertiesEntity?.fromMap(map['properties']),
      collection: NFTCollection?.fromMap(map['collection']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NFTEntity.fromJson(String source) =>
      NFTEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NFTEntity(name: $name, description: $description, image: $image, sellerFeeBasisPoints: $sellerFeeBasisPoints, externalUrl: $externalUrl, attributes: $attributes, properties: $properties, collection: $collection)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is NFTEntity &&
        o.name == name &&
        o.description == description &&
        o.image == image &&
        o.sellerFeeBasisPoints == sellerFeeBasisPoints &&
        o.externalUrl == externalUrl &&
        listEquals(o.attributes, attributes) &&
        o.properties == properties &&
        o.collection == collection;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        image.hashCode ^
        sellerFeeBasisPoints.hashCode ^
        externalUrl.hashCode ^
        attributes.hashCode ^
        properties.hashCode ^
        collection.hashCode;
  }
}
