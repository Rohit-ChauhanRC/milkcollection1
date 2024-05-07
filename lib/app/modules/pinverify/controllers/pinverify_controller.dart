import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:milkcollection/app/constants/contants.dart';
import 'package:milkcollection/app/data/local_database/farmer_db.dart';
import 'package:milkcollection/app/data/local_database/milk_collection_db.dart';
import 'package:milkcollection/app/data/models/farmer_list_model.dart';
import 'package:milkcollection/app/data/models/milk_collection_model.dart';
import 'package:milkcollection/app/routes/app_pages.dart';
import 'package:milkcollection/app/utils/utils.dart';

class PinverifyController extends GetxController {
  //

  final box = GetStorage();

  final FarmerDB farmerDB = FarmerDB();

  final MilkCollectionDB milkCollectionDB = MilkCollectionDB();

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

  final RxList<MilkCollectionModel> _restoreData =
      RxList<MilkCollectionModel>();
  List<MilkCollectionModel> get restoreData => _restoreData;
  set restoreData(List<MilkCollectionModel> lst) => _restoreData.assignAll(lst);

  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    farmerData.assignAll(await farmerDB.fetchAll());
    restoreData.assignAll(await milkCollectionDB.fetchAll());
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
        await getFarmerList().then((value) async {
          await postMilkCollectionDataDB();
        });
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

  Future<void> postMilkCollectionDataDB() async {
    // print(farmerData.first.farmerId);
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
