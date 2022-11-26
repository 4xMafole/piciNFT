import 'dart:convert';

class MetadataNFT {
  String name;
  String symbol;
  String dataUri;

  MetadataNFT({
    required this.name,
    required this.symbol,
    required this.dataUri,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'symbol': symbol,
      'dataUri': dataUri,
    };
  }

  factory MetadataNFT.fromMap(Map<String, dynamic> map) {
    return MetadataNFT(
      name: map['name'],
      symbol: map['symbol'],
      dataUri: map['dataUri'],
    );
  }

  String toJson() => json.encode(toMap());
}
