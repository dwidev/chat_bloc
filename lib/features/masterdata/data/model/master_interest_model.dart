import 'mastedata_model.dart';

class MasterDataInterestModel extends MasterDataModel {
  final int icon;

  MasterDataInterestModel({
    required super.code,
    required super.name,
    required this.icon,
  });

  factory MasterDataInterestModel.fromMap(Map<String, dynamic> map) {
    final parent = MasterDataModel.fromMap(map);

    return MasterDataInterestModel(
      icon: map['icon'] as int,
      code: parent.code,
      name: parent.name,
    );
  }
}
