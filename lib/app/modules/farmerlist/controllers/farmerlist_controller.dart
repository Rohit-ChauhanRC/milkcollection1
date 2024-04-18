import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:milkcollection/app/data/local_database/farmer_db.dart';
import 'package:milkcollection/app/data/models/farmer_list_model.dart';
import 'package:milkcollection/app/utils/utils.dart';

class FarmerlistController extends GetxController {
  //

  final box = GetStorage();

  final FarmerDB farmerDB = FarmerDB();

  final RxString _search = ''.obs;
  String get search => _search.value;
  set search(String mob) => _search.value = mob;

  final RxList<FarmerListModel> _farmerData = RxList<FarmerListModel>();
  List<FarmerListModel> get farmerData => _farmerData;
  set farmerData(List<FarmerListModel> lst) => _farmerData.assignAll(lst);

  final RxBool _circularProgress = true.obs;
  bool get circularProgress => _circularProgress.value;
  set circularProgress(bool v) => _circularProgress.value = v;

  @override
  void onInit() async {
    super.onInit();

    // final db = await farmerDB.fetchAll();
    // if (db.isEmpty) {
    //   await getFarmerList();
    // } else {
    farmerData.assignAll(await farmerDB.fetchAll());
    // }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getFarmerList() async {
    try {
      var res = await http.get(
        Uri.parse(
            "http://Payment.maklife.in:9019/api/GetFarmerList?CollectionCenterId=${box.read("centerId")}"),
      );

      if (res.statusCode == 200) {
        farmerData.assignAll(farmerListModelFromMap(res.body));
        if (farmerData.isNotEmpty) {
          for (var e in farmerData) {
            farmerDB.create(
              farmerId: e.farmerId,
              calculationsID: e.calculationsId,
              farmerName: e.farmerName,
              bankName: e.bankName,
              branchName: e.branchName,
              aadharCardNo: e.aadharCardNo,
              accountName: e.accountName,
              address: e.address,
              centerID: e.centerId,
              exportParameter1: e.exportParameter1,
              exportParameter2: e.exportParameter2,
              exportParameter3: e.exportParameter3,
              iFSCCode: e.ifscCode,
              mCPGroup: e.mcpGroup,
              mobileNumber: e.mobileNumber,
              modeOfPay: e.modeOfPay,
              noOfBuffalos: e.noOfBuffalos,
              noOfCows: e.noOfCows,
              rFID: e.rfId,
            );
          }
        }
        print(farmerData);
      } else {
        //
        Utils.showDialog(json.decode(res.body));
      }
      circularProgress = true;
    } catch (e) {
      // apiLopp(i);
      circularProgress = true;
    }
  }
}
