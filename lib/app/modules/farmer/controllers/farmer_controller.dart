import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:milkcollection/app/constants/contants.dart';
import 'package:milkcollection/app/data/local_database/farmer_db.dart';
import 'package:milkcollection/app/data/models/farmer_list_model.dart';
import 'package:milkcollection/app/modules/farmerlist/controllers/farmerlist_controller.dart';
import 'package:milkcollection/app/utils/utils.dart';

class FarmerController extends GetxController {
  //
  GlobalKey<FormState> farmerFormKey = GlobalKey();

  final FarmerlistController farmerlistController = FarmerlistController();

  final FarmerDB farmerDB = FarmerDB();

  final RxList<ConnectivityResult> _connectionStatus =
      [ConnectivityResult.none].obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final box = GetStorage();

  final RxBool _type = true.obs;
  bool get type => _type.value;
  set type(bool v) => _type.value = v;

  final RxString _title = ''.obs;
  String get title => _title.value;
  set title(String mob) => _title.value = mob;

  final RxString _farmerName = ''.obs;
  String get farmerName => _farmerName.value;
  set farmerName(String mob) => _farmerName.value = mob;

  final RxString _bankName = ''.obs;
  String get bankName => _bankName.value;
  set bankName(String mob) => _bankName.value = mob;

  final RxString _branchName = ''.obs;
  String get branchName => _branchName.value;
  set branchName(String mob) => _branchName.value = mob;

  final RxString _accountNumber = ''.obs;
  String get accountNumber => _accountNumber.value;
  set accountNumber(String mob) => _accountNumber.value = mob;

  final RxString _ifscCode = ''.obs;
  String get ifscCode => _ifscCode.value;
  set ifscCode(String mob) => _ifscCode.value = mob;

  final RxString _aadharCard = ''.obs;
  String get aadharCard => _aadharCard.value;
  set aadharCard(String mob) => _aadharCard.value = mob;

  final RxString _mobileNumber = ''.obs;
  String get mobileNumber => _mobileNumber.value;
  set mobileNumber(String mob) => _mobileNumber.value = mob;

  final RxString _numberOfCows = ''.obs;
  String get numberOfCows => _numberOfCows.value;
  set numberOfCows(String mob) => _numberOfCows.value = mob;

  final RxString _numberOfBuffalo = ''.obs;
  String get numberOfBuffalo => _numberOfBuffalo.value;
  set numberOfBuffalo(String mob) => _numberOfBuffalo.value = mob;

  final RxString _address = ''.obs;
  String get address => _address.value;
  set address(String mob) => _address.value = mob;

  final RxInt _radio = 0.obs;
  int get radio => _radio.value;
  set radio(int i) => _radio.value = i;

  final RxBool _circularProgress = true.obs;
  bool get circularProgress => _circularProgress.value;
  set circularProgress(bool v) => _circularProgress.value = v;

  final Rx<FarmerListModel> _farmerData = (FarmerListModel()).obs;
  FarmerListModel get farmerData => _farmerData.value;
  set farmerData(FarmerListModel lst) => _farmerData.value = lst;

  @override
  void onInit() async {
    super.onInit();
    type = Get.arguments[0];
    if (Get.arguments[0] == true) {
      title = "Farmer Detail";
      await getFarmerById();
    } else {
      title = "Add Farmer";
    }

    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      _connectionStatus.value = result;
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getFarmerById() async {
    await farmerDB.fetchById(Get.arguments[1].toString()).then((value) {
      farmerName = value.farmerName!;
      bankName = value.bankName!;
      branchName = value.branchName!;
      accountNumber = value.accountName!;
      ifscCode = value.ifscCode!;
      aadharCard = value.aadharCardNo!;
      mobileNumber = value.mobileNumber!;
      numberOfCows = value.noOfCows.toString();
      numberOfBuffalo = value.noOfBuffalos.toString();
      address = value.address!;
      radio = value.modeOfPay!;
    });
  }

  Future<void> addFarmer() async {
    try {
      var res =
          await http.post(Uri.parse("$baseUrlConst/$addFarmerConst"), body: {
        "CalculationsID": "${Get.arguments[1] + 1}",
        "FarmerName": farmerName,
        "BankName": bankName,
        "BranchName": branchName,
        "AccountName": accountNumber,
        "IFSCCode": ifscCode,
        "AadharCardNo": aadharCard,
        "MobileNumber": mobileNumber,
        "NoOfCows": numberOfCows,
        "NoOfBuffalos": numberOfBuffalo,
        "ModeOfPay": radio.toString(),
        "RF_ID": "null",
        "Address": address,
        "ExportParameter1": "0",
        "ExportParameter2": "0",
        "ExportParameter3": "0",
        "CenterID": box.read("centerId").toString(),
        "MCPGroup": "Maklife"
      });
      print(jsonDecode(res.body));

      if (res.statusCode == 200 && jsonDecode(res.body) == "Added succes..") {
        //
        // await farmerlistController.pinverifyController
        //     .getFamerDataDB()
        //     .then((value) async {
        //   await farmerlistController.farmerDB.deleteTable().then((value) async {
        //     await farmerlistController.pinverifyController.getFarmerList();
        //   });
        // });
        await farmerlistController.pinverifyController.getFarmerList();

        // print(jsonDecode(res.body));
      } else {
        //
        await farmerlistController.farmerDB.create(
          farmerId: int.tryParse("${Get.arguments[1] + 1}")!,
          farmerName: farmerName,
          bankName: bankName,
          branchName: branchName,
          aadharCardNo: aadharCard,
          accountName: accountNumber,
          address: address,
          centerID: int.tryParse("${box.read("centerId")}")!,
          exportParameter1: "0",
          exportParameter2: "0",
          exportParameter3: "0",
          iFSCCode: ifscCode,
          mCPGroup: "Maklife",
          mobileNumber: mobileNumber,
          modeOfPay: radio,
          noOfBuffalos: int.tryParse(numberOfBuffalo),
          noOfCows: int.tryParse(numberOfCows),
          rFID: "null",
          FUploaded: 0,
        );
        // await farmerlistController.pinverifyController.getFarmerList();
        farmerlistController.pinverifyController.farmerData.assignAll(
            await farmerlistController.pinverifyController.farmerDB.fetchAll());

        Utils.showDialog(json.decode(res.body));
      }
      circularProgress = true;
    } catch (e) {
      // apiLopp(i);
      print(e);
      circularProgress = true;
      await farmerlistController.farmerDB
          .create(
        farmerId: int.tryParse("${Get.arguments[1] + 1}")!,
        farmerName: farmerName,
        bankName: bankName,
        branchName: branchName,
        aadharCardNo: aadharCard,
        accountName: accountNumber,
        address: address,
        centerID: int.tryParse("${box.read("centerId")}")!,
        exportParameter1: "0",
        exportParameter2: "0",
        exportParameter3: "0",
        iFSCCode: ifscCode,
        mCPGroup: "Maklife",
        mobileNumber: mobileNumber,
        modeOfPay: radio,
        noOfBuffalos: int.tryParse(numberOfBuffalo),
        noOfCows: int.tryParse(numberOfCows),
        rFID: "null",
        FUploaded: 0,
      )
          .then((value) async {
        farmerlistController.pinverifyController.farmerData.assignAll(
            await farmerlistController.pinverifyController.farmerDB.fetchAll());
      });
    }
    Get.back();
  }

  Future<void> localFarmerUpdate() async {
    await farmerDB
        .update(
            address: address,
            aadharCardNo: aadharCard,
            mobileNumber: mobileNumber,
            noOfBuffalos: int.parse(numberOfBuffalo),
            noOfCows: int.parse(numberOfCows),
            modeOfPay: radio)
        .then((value) {
      Utils.showSnackbar("Farmer details saved..");
      Get.back();
    });
  }
}
