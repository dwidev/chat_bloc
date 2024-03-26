import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../datasource/masterdata_datasource.dart';
import '../model/mastedata_model.dart';
import '../model/master_interest_model.dart';

@LazySingleton()
class MasterDataRepository {
  final MasterDataDasource masterDataDasource;

  MasterDataRepository({required this.masterDataDasource});

  Future<List<MasterDataModel>> getListLookingsFor() async {
    final response = await masterDataDasource.getListLookingFor();
    return response;
  }

  Future<List<MasterDataInterestModel>> getListInterests() async {
    final response = await masterDataDasource.getListInterests();
    return response;
  }

  @disposeMethod
  void dispose() {
    masterDataDasource.dispose();
    debugPrint("$this disposed");
  }
}
