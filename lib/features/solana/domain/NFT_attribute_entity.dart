import 'dart:convert';

class NFTAttributeEntity {
  String? displayType;
  String traitType;
  String value;
  NFTAttributeEntity({
    this.displayType,
    required this.traitType,
    required this.value,
  });

  NFTAttributeEntity merge(NFTAttributeEntity model) {
    return NFTAttributeEntity(
      displayType: model.displayType ?? displayType,
      traitType: model.traitType,
      value: model.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'display_type': displayType,
      'trait_type': traitType,
      'value': value,
    };
  }

  factory NFTAttributeEntity.fromMap(Map<String, dynamic> map) {
    return NFTAttributeEntity(
      displayType: map['display_type'],
      traitType: map['trait_type'],
      value: map['value'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NFTAttributeEntity.fromJson(String source) =>
      NFTAttributeEntity.fromMap(json.decode(source));

  @override
  String toString() =>
      'AttributeEntity(displayType: $displayType, traitType: $traitType, value: $value)';

  @override
  bool operator ==(Object obj) {
    if (identical(this, obj)) return true;

    return obj is NFTAttributeEntity &&
        obj.displayType == displayType &&
        obj.traitType == traitType &&
        obj.value == value;
  }

  @override
  int get hashCode =>
      displayType.hashCode ^ traitType.hashCode ^ value.hashCode;
}
