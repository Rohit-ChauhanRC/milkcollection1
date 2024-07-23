import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:milkcollection/app/constants/contants.dart';
import 'package:milkcollection/app/data/local_database/farmer_db.dart';
import 'package:milkcollection/app/data/local_database/milk_collection_db.dart';
import 'package:milkcollection/app/data/models/farmer_list_model.dart';
import 'package:milkcollection/app/data/models/milk_collection_model.dart';
import 'package:milkcollection/app/routes/app_pages.dart';
import 'package:milkcollection/app/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

  final RxString _version = "".obs;
  String get version => _version.value;
  set version(String str) => _version.value = str;

  @override
  void onInit() async {
    super.onInit();
    farmerData.assignAll(await farmerDB.fetchAll());
    restoreData.assignAll(await milkCollectionDB.fetchAll());
    await findVersion();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    _check.close();
    _circularProgress.close();
    _pin.close();
    // _initialized.close();
  }

  Future<void> findVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    version = packageInfo.version;
  }

  Future<dynamic> login() async {
    Utils.closeKeyboard();
    if (!loginFormKey.currentState!.validate()) {
      return null;
    }

    if (box.read(pinConst) == pin) {
      bool result = await InternetConnection().hasInternetAccess;

      if (result) {
        circularProgress = true;
        await getFamerDataDB().then((v) async {
          await getFarmerList().then((value) async {
            await postMilkCollectionDataDB().then((value) async {
              await geMilkCollectionList().then((v) {
                box.write(verifyConst, true).then((value) => {
                      circularProgress = false,
                      Get.offNamed(Routes.HOME),
                    });
              });
            });
          });
        });
      } else {
        box.write(verifyConst, true).then((value) => Get.offNamed(Routes.HOME));
      }
    } else {
      Utils.showDialog("Incorrect pin!");
    }
  }

  dateFormat(DateTime date) {
    return DateFormat("dd-MMM-yyyy").format(date);
  }

  Future<void> geMilkCollectionList() async {
    try {
      var res = await http.get(
          Uri.parse(
            "$baseUrlConst/$restoreDataConst?CollectionCenterId=${box.read("centerId")}&FromDate=${dateFormat(DateTime.now().subtract(const Duration(days: 90)))}&ToDate=${dateFormat(DateTime.now())}",
          ),
          headers: {"Content-Type": "application/json"});

      if (res.statusCode == 200) {
        restoreData.assignAll([]);
        restoreData.assignAll(milkCollectionModelFromMap(res.body));
        if (restoreData.isNotEmpty) {
          milkCollectionDB.deleteTable();
          for (var e in restoreData) {
            milkCollectionDB.create(
              Added_Water: e.addedWater,
              Analyze_Mode: e.analyzeMode,
              CollectionCenterId: e.collectionCenterId.toString(),
              CollectionCenterName: e.collectionCenterName,
              Collection_Date: e.collectionDate,
              Collection_Mode: e.collectionMode,
              FAT: e.fat,
              FarmerId: e.farmerId,
              Farmer_Name: e.farmerName,
              Inserted_Time: e.insertedTime,
              Milk_Status: e.milkStatus,
              Milk_Type: e.milkType,
              Qty: e.qty,
              Rate_Chart_Name: e.rateChartName,
              Rate_Per_Liter: e.ratePerLiter,
              SNF: e.snf,
              Scale_Mode: e.scaleMode,
              Shift: e.shift,
              Total_Amt: e.totalAmt,
              FUploaded: 1,
            );
          }
        }
      } else {}
    } catch (e) {}
  }

  Future<void> getFamerDataDB() async {
    // print(farmerData.first.farmerId);
    if (farmerData.isNotEmpty) {
      for (var e in farmerData) {
        if (e.FUploaded == 0) {
          try {
            var res = await http.post(
              Uri.parse("$baseUrlConst/$addFarmerConst"),
              body: {
                "FarmerName": e.farmerName,
                "BankName": e.bankName!.isNotEmpty ? e.bankName : "NA",
                "BranchName": e.branchName!.isNotEmpty ? e.branchName : "NA",
                "AccountName": e.accountName!.isNotEmpty ? e.accountName : "NA",
                "IFSCCode": e.ifscCode!.isNotEmpty ? e.ifscCode : "NA",
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
                "CenterID": box.read(centerIdConst).toString(),
                "MCPGroup": "Maklife"
              },
              headers: {
                "Access-Control-Allow-Origin":
                    "*", // Required for CORS support to work
                "Access-Control-Allow-Credentials":
                    "true", // Required for cookies, authorization headers with HTTPS
                "Access-Control-Allow-Headers":
                    "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
                "Access-Control-Allow-Methods": "POST, OPTIONS, GET"
              },
            );

            if (res.statusCode == 200) {
            } else {
              //
            }
            // circularProgress = true;
          } catch (e) {
            // apiLopp(i);
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
            var res = await http.post(
              Uri.parse("$baseUrlConst/$dailyCollection"),
              body: {
                "Collection_Date": e.collectionDate.toString(),
                "Inserted_Time": e.insertedTime.toString(),
                "Calculations_ID": "",
                "FarmerId": e.farmerId.toString(),
                "Farmer_Name": e.farmerName.toString(),
                "Collection_Mode": e.collectionMode.toString(),
                "Scale_Mode": e.scaleMode.toString(),
                "Analyze_Mode": e.analyzeMode.toString(),
                "Milk_Status": e.milkStatus.toString(),
                "Milk_Type": e.milkType.toString(),
                "Rate_Chart_Name": e.rateChartName.toString(),
                "Qty": e.qty.toString(),
                "FAT": e.fat.toString(),
                "SNF": e.snf.toString(),
                "Added_Water": e.addedWater.toString(),
                "Rate_Per_Liter": e.ratePerLiter.toString(),
                "Total_Amt": e.totalAmt.toString(),
                "CollectionCenterId": e.collectionCenterId.toString(),
                "CollectionCenterName": e.collectionCenterName.toString(),
                "Shift": e.shift.toString(),
              },
              headers: {
                "Access-Control-Allow-Origin":
                    "*", // Required for CORS support to work
                "Access-Control-Allow-Credentials":
                    "true", // Required for cookies, authorization headers with HTTPS
                "Access-Control-Allow-Headers":
                    "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
                "Access-Control-Allow-Methods": "POST, OPTIONS, GET"
              },
            );

            if (res.statusCode == 200) {
              await milkCollectionDB.update(
                  farmerId: e.farmerId!, FUploaded: 1);
            }
          } catch (e) {}
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
        }
      } else {
        // Get.toNamed(Routes.HOME);
        //
        // Utils.showDialog(json.decode(res.body));
      }
      // circularProgress = true;
    } catch (e) {
      // Get.toNamed(Routes.HOME);
      // apiLopp(i);
      // circularProgress = true;
    }
  }
}
