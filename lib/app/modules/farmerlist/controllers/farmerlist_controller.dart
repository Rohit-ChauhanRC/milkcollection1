import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:milkcollection/app/data/local_database/farmer_db.dart';
import 'package:milkcollection/app/data/local_database/milk_collection_db.dart';
import 'package:milkcollection/app/data/models/farmer_list_model.dart';

import '../../../data/models/milk_collection_model.dart';

class FarmerlistController extends GetxController {
  //

  final box = GetStorage();
  // final PinverifyController pinverifyController = Get.find();

  final FarmerDB farmerDB = FarmerDB();

  final MilkCollectionDB milkCollectionDB = MilkCollectionDB();

  final RxString _search = ''.obs;
  String get search => _search.value;
  set search(String mob) => _search.value = mob;

  final RxBool _circularProgress = true.obs;
  bool get circularProgress => _circularProgress.value;
  set circularProgress(bool v) => _circularProgress.value = v;

  final RxBool _searchActive = false.obs;
  bool get searchActive => _searchActive.value;
  set searchActive(bool v) => _searchActive.value = v;

  final RxList<FarmerListModel> _searchfarmerData = RxList<FarmerListModel>();
  List<FarmerListModel> get searchfarmerData => _searchfarmerData;
  set searchfarmerData(List<FarmerListModel> lst) =>
      _searchfarmerData.assignAll(lst);

  final RxList<FarmerListModel> _farmerData = RxList<FarmerListModel>();
  List<FarmerListModel> get farmerData => _farmerData;
  set farmerData(List<FarmerListModel> lst) => _farmerData.assignAll(lst);

  final RxList<MilkCollectionModel> _restoreData =
      RxList<MilkCollectionModel>();
  List<MilkCollectionModel> get restoreData => _restoreData;
  set restoreData(List<MilkCollectionModel> lst) => _restoreData.assignAll(lst);

  @override
  void onInit() async {
    super.onInit();

    await getFarmerListLocal();
    // restoreData.assignAll(await milkCollectionDB.fetchAll());
  }

  @override
  void onReady() async {
    super.onReady();
    // await getFarmerList();
  }

  @override
  void onClose() {
    super.onClose();
    _farmerData.close();
    _circularProgress.close();
    _restoreData.close();
    _search.close();
    _searchActive.close();
  }

  getFarmerListLocal() async {
    circularProgress = true;

    farmerData.assignAll(await farmerDB.fetchAll());
    circularProgress = false;
  }

  Future<void> getSearchFarmerData() async {
    for (var i = 0; i < farmerData.length; i++) {
      if (farmerData[i]
          .farmerName
          .toString()
          .toLowerCase()
          .contains(search.trim().toLowerCase())) {
        searchfarmerData.assign(farmerData[i]);

        update();
        print(farmerData[i].farmerName);
      }
    }

    // print(searchfarmerData);
  }

  Future<void> searchAll() async {
    farmerData.assignAll(await farmerDB.fetchAll());
  }
}
