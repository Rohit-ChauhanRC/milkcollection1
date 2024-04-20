import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:milkcollection/app/data/local_database/farmer_db.dart';
import 'package:milkcollection/app/data/models/farmer_list_model.dart';
import 'package:milkcollection/app/modules/pinverify/controllers/pinverify_controller.dart';
import 'package:milkcollection/app/utils/utils.dart';

class FarmerlistController extends GetxController {
  //

  final box = GetStorage();
  final PinverifyController pinverifyController = Get.find();

  final FarmerDB farmerDB = FarmerDB();

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

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getSearchFarmerData() async {
    // searchfarmerData.assignAll(await farmerDB.fetchByName(search.trim()));
    pinverifyController.farmerData;

    for (var i = 0; i < pinverifyController.farmerData.length; i++) {
      if (pinverifyController.farmerData[i].farmerName
          .toString()
          .toLowerCase()
          .contains(search.trim().toLowerCase())) {
        searchfarmerData.add(pinverifyController.farmerData[i]);

        update();
        print(pinverifyController.farmerData[i].farmerName);
      }
    }

    print(searchfarmerData);
  }
}
