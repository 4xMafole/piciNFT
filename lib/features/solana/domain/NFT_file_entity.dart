import 'dart:convert';

class NFTFileEntity {
  String type;
  String uri;
  NFTFileEntity({
    required this.type,
    required this.uri,
  });

  NFTFileEntity merge(NFTFileEntity model) {
    return NFTFileEntity(
      type: model.type,
      uri: model.uri,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'uri': uri,
    };
  }

  factory NFTFileEntity.fromMap(Map<String, dynamic> map) {
    return NFTFileEntity(
      type: map['type'],
      uri: map['uri'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NFTFileEntity.fromJson(String source) =>
      NFTFileEntity.fromMap(json.decode(source));

  @override
  String toString() => 'NFTFileEntity(type: $type, uri: $uri)';

  @override
  bool operator ==(Object obj) {
    if (identical(this, obj)) return true;

    return obj is NFTFileEntity && obj.type == type && obj.uri == uri;
  }

  @override
  int get hashCode => type.hashCode ^ uri.hashCode;
}
