import 'dart:convert';

@Deprecated("Refer to this structure")
class NFTCollection {
  String name;
  String family;
  NFTCollection({
    required this.name,
    required this.family,
  });

  NFTCollection merge(NFTCollection model) {
    return NFTCollection(
      name: model.name,
      family: model.family,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'family': family,
    };
  }

  factory NFTCollection.fromMap(Map<String, dynamic> map) {
    return NFTCollection(
      name: map['name'],
      family: map['family'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NFTCollection.fromJson(String source) =>
      NFTCollection.fromMap(json.decode(source));

  @override
  String toString() => 'NFTCollection(name: $name, family: $family)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is NFTCollection && o.name == name && o.family == family;
  }

  @override
  int get hashCode => name.hashCode ^ family.hashCode;
}
