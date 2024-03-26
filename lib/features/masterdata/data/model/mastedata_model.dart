import 'dart:convert';

class MasterDataModel {
  final String code;
  final String name;

  MasterDataModel({required this.code, required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'name': name,
    };
  }

  factory MasterDataModel.fromMap(Map<String, dynamic> map) {
    return MasterDataModel(
      code: map['code'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MasterDataModel.fromJson(String source) =>
      MasterDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MasterDataModel(code: $code, name: $name)';
}
