import 'dart:convert';

@Deprecated("Refer to this structure")
class NFTCreatorEntity {
  String address;
  double share;
  NFTCreatorEntity({
    required this.address,
    required this.share,
  });

  NFTCreatorEntity merge(NFTCreatorEntity model) {
    return NFTCreatorEntity(
      address: model.address,
      share: model.share,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'share': share,
    };
  }

  factory NFTCreatorEntity.fromMap(Map<String, dynamic> map) {
    return NFTCreatorEntity(
      address: map['address'],
      share: map['share'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NFTCreatorEntity.fromJson(String source) =>
      NFTCreatorEntity.fromMap(json.decode(source));

  @override
  String toString() => 'NFTCreatorEntity(address: $address, share: $share)';

  @override
  bool operator ==(Object obj) {
    if (identical(this, obj)) return true;

    return obj is NFTCreatorEntity &&
        obj.address == address &&
        obj.share == share;
  }

  @override
  int get hashCode => address.hashCode ^ share.hashCode;
}
