import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:milkcollection/app/constants/contants.dart';
import 'package:milkcollection/app/data/local_database/farmer_db.dart';
import 'package:milkcollection/app/data/models/farmer_list_model.dart';
import 'package:milkcollection/app/routes/app_pages.dart';
import 'package:milkcollection/app/utils/utils.dart';

class PinverifyController extends GetxController {
  //

  final box = GetStorage();

  final FarmerDB farmerDB = FarmerDB();

  GlobalKey<FormState> loginFormKey = GlobalKey();

  final RxBool _circularProgress = true.obs;
  bool get circularProgress => _circularProgress.value;
  set circularProgress(bool v) => _circularProgress.value = v;

  final RxBool _check = false.obs;
  bool get check => _check.value;
  set check(bool v) => _check.value = v;

  final RxString _pin = ''.obs;
  String get pin => _pin.value;
  set pin(String mob) => _pin.value = mob;

  final RxList<FarmerListModel> _farmerData = RxList<FarmerListModel>();
  List<FarmerListModel> get farmerData => _farmerData;
  set farmerData(List<FarmerListModel> lst) => _farmerData.assignAll(lst);

  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    farmerData.assignAll(await farmerDB.fetchAll());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<dynamic> login() async {
    Utils.closeKeyboard();
    if (!loginFormKey.currentState!.validate()) {
      return null;
    }

    if (box.read(pinConst) == pin) {
      await getFamerDataDB().then((v) async {
        await getFarmerList();
      });

      box.write(verifyConst, true).then((value) => Get.toNamed(Routes.HOME));
    } else {
      Utils.showDialog("Incorrect pin!");
    }
  }

  Future<void> getFamerDataDB() async {
    // print(farmerData.first.farmerId);
    if (farmerData.isNotEmpty) {
      for (var e in farmerData) {
        if (e.FUploaded == 0) {
          print(e.farmerId);
          try {
            var res = await http
                .post(Uri.parse("$baseUrlConst/$addFarmerConst"), body: {
              "FarmerName": e.farmerName,
              "BankName": e.bankName,
              "BranchName": e.branchName,
              "AccountName": e.accountName,
              "IFSCCode": e.ifscCode,
              "AadharCardNo": e.aadharCardNo,
              "MobileNumber": e.mobileNumber,
              "NoOfCows": e.noOfCows.toString(),
              "NoOfBuffalos": e.noOfBuffalos.toString(),
              "ModeOfPay": e.modeOfPay.toString(),
              "RF_ID": "null",
              "Address": e.address,
              "ExportParameter1": "0",
              "ExportParameter2": "0",
              "ExportParameter3": "0",
              "CenterID": box.read(centerIdConst),
              "MCPGroup": "Maklife"
            });
            print(jsonDecode(res.body));

            if (res.statusCode == 200) {
              print(jsonDecode(res.body));
            } else {
              //
            }
            circularProgress = true;
          } catch (e) {
            // apiLopp(i);
            print(e);
          }
        }
      }
    }
  }

  Future<void> getFarmerList() async {
    try {
      var res = await http.get(
        Uri.parse(
            "$baseUrlConst/$getFarmerConst?CollectionCenterId=${box.read(centerIdConst)}"),
      );

      if (res.statusCode == 200) {
        farmerData.assignAll(farmerListModelFromMap(res.body));

        if (farmerData.isNotEmpty) {
          for (var e in farmerData) {
            farmerDB.create(
              farmerId: e.farmerId!,
              farmerName: e.farmerName!,
              bankName: e.bankName!,
              branchName: e.branchName!,
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
          print(farmerData);
        }
      } else {
        // Get.toNamed(Routes.HOME);
        //
        // Utils.showDialog(json.decode(res.body));
      }
      circularProgress = true;
    } catch (e) {
      // Get.toNamed(Routes.HOME);
      // apiLopp(i);
      circularProgress = true;
    }
  }
}
