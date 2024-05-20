import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:milkcollection/app/constants/contants.dart';
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
    farmerData.assignAll(await farmerDB.fetchAll());
    restoreData.assignAll(await milkCollectionDB.fetchAll());
  }

  @override
  void onReady() async {
    super.onReady();
    // await getFarmerList();
    await getFarmerList();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getFarmerList() async {
    try {
      var res = await http.get(
        Uri.parse(
            "$baseUrlConst/$getFarmerConst?CollectionCenterId=${box.read(centerIdConst)}"),
      );

      if (res.statusCode == 200) {
        farmerData.assignAll(farmerListModelFromMap(res.body));
      } else {}
      circularProgress = true;
    } catch (e) {
      circularProgress = true;
    }
  }

  Future<void> postMilkCollectionDataDB() async {
    if (restoreData.isNotEmpty) {
      for (var e in restoreData) {
        if (e.FUploaded == 0) {
          try {
            var res = await http
                .post(Uri.parse("$baseUrlConst/$dailyCollection"), body: {
              "Collection_Date": e.collectionDate,
              "Inserted_Time": e.insertedTime,
              "Calculations_ID": e.calculationsId,
              "FarmerId": e.farmerId,
              "Farmer_Name": e.farmerName,
              "Collection_Mode": e.collectionMode,
              "Scale_Mode": e.scaleMode,
              "Analyze_Mode": e.analyzeMode,
              "Milk_Status": e.milkStatus,
              "Milk_Type": e.milkType,
              "Rate_Chart_Name": e.rateChartName,
              "Qty": e.qty,
              "FAT": e.fat,
              "SNF": e.snf,
              "Added_Water": e.addedWater,
              "Rate_Per_Liter": e.ratePerLiter,
              "Total_Amt": e.totalAmt,
              "CollectionCenterId": e.collectionCenterId,
              "CollectionCenterName": e.collectionCenterName,
              "Shift": e.shift,
            });

            if (res.statusCode == 200 && jsonDecode(res.body) == "Inserted") {
            } else {
              //
            }
            circularProgress = true;
          } catch (e) {
            print(e);
          }
        }
      }
    }
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
