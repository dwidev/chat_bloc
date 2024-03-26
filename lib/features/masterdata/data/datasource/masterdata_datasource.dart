import '../model/mastedata_model.dart';
import '../model/master_interest_model.dart';

abstract class MasterDataDasource {
  Future<List<MasterDataModel>> getListLookingFor();
  Future<List<MasterDataInterestModel>> getListInterests();

  void dispose();
}
