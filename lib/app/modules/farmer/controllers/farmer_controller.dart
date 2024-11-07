import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
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
  GlobalKey<FormState>? farmerFormKey = GlobalKey<FormState>();
  final FocusNode myFocusNode = FocusNode();

  // final FarmerlistController farmerlistController = FarmerlistController();
  final FarmerlistController farmerlistController =
      Get.put<FarmerlistController>(FarmerlistController());

  final FarmerDB farmerDB = FarmerDB();

  final box = GetStorage();

  final RxBool _progresBar = RxBool(true);
  bool get progressBar => _progresBar.value;
  set progressBar(bool b) => _progresBar.value = b;

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

  TextEditingController address1 = TextEditingController();

  final RxInt _radio = 0.obs;
  int get radio => _radio.value;
  set radio(int i) => _radio.value = i;

  final RxBool _circularProgress = true.obs;
  bool get circularProgress => _circularProgress.value;
  set circularProgress(bool v) => _circularProgress.value = v;

  final Rx<FarmerListModel> _farmerData = (FarmerListModel()).obs;
  FarmerListModel get farmerData => _farmerData.value;
  set farmerData(FarmerListModel lst) => _farmerData.value = lst;

  final RxString _farmerId = ''.obs;
  String get farmerId => _farmerId.value;
  set farmerId(String mob) => _farmerId.value = mob;

  final RxString _fId = ''.obs;
  String get fId => _fId.value;
  set fId(String mob) => _fId.value = mob;

  @override
  void onInit() async {
    super.onInit();
    type = Get.arguments[0];
    fId = Get.arguments[1].toString();
    if (Get.arguments[0] == true) {
      title = "Farmer Detail";
      await getFarmerById();
    } else {
      title = "Add Farmer";
      progressBar = false;
    }
  }

  @override
  void onReady() async {
    super.onReady();
    if (Get.arguments[0] == true) {
      title = "Farmer Detail";
      await getFarmerById();
    } else {
      title = "Add Farmer";
      progressBar = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    _aadharCard.close();
    _accountNumber.close();
    _address.close();
    _bankName.close();
    _branchName.close();
    _circularProgress.close();
    _farmerData.close();
    _farmerName.close();
    _ifscCode.close();
    _mobileNumber.close();
    _numberOfBuffalo.close();
    _numberOfCows.close();
    _radio.close();
    _title.close();
    _type.close();
  }

  Future<void> getFarmerById() async {
    await farmerDB.fetchById(fId.toString()).then((value) {
      farmerName = value.farmerName.toString();
      bankName = value.bankName.toString();
      branchName = value.branchName.toString();
      accountNumber = value.accountName.toString();
      ifscCode = value.ifscCode.toString();
      aadharCard = value.aadharCardNo.toString();
      mobileNumber = value.mobileNumber.toString();
      numberOfCows = value.noOfCows.toString();
      numberOfBuffalo = value.noOfBuffalos.toString();
      address = value.address.toString();
      radio = value.modeOfPay!;
    }).then((value) {
      progressBar = false;
    });
  }

  String getFarmerIdFinal() {
    var farmerfinalId = "";
    if (int.parse(fId) == 0) {
      farmerfinalId = "${box.read(centerIdConst)}0001";
    } else {
      farmerfinalId = "${int.parse(fId) + 1}";
    }

    return farmerfinalId;
  }

  Future<void> addFarmer() async {
    try {
      final _body = <String, String>{
        "CalculationsID": getFarmerIdFinal().toString(),
        "FarmerName": farmerName,
        "BankName": bankName.isNotEmpty ? bankName : "NA",
        "BranchName": branchName.isNotEmpty ? branchName : "NA",
        "AccountName": accountNumber.isNotEmpty ? accountNumber : "NA",
        "IFSCCode": ifscCode.isNotEmpty ? ifscCode : "NA",
        "AadharCardNo": aadharCard.isNotEmpty ? aadharCard : "",
        "MobileNumber": mobileNumber,
        "NoOfCows": numberOfCows,
        "NoOfBuffalos": numberOfBuffalo,
        "ModeOfPay": radio.toString(),
        "RF_ID": "null",
        "Address": address.isNotEmpty ? address : "NA",
        "ExportParameter1": "0",
        "ExportParameter2": "0",
        "ExportParameter3": "0",
        "CenterID": box.read("centerId").toString(),
        "MCPGroup": "Maklife",
      };
      var res = await http.post(Uri.parse("$baseUrlConst/$addFarmerConst"),
          body: _body);

      if (res.statusCode == 200 && jsonDecode(res.body) == "Added succes..") {
        Utils.showSnackbar("Add Successfully!");
      }
      circularProgress = true;
    } catch (e) {
      circularProgress = true;
    }
  }

  Future<void> createFarmerLocal(int fupload) async {
    await farmerlistController.farmerDB.create(
      farmerId: int.tryParse(getFarmerIdFinal())!,
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
      FUploaded: fupload,
    );
  }

  Future<void> localFarmerUpdate(bool result) async {
    await farmerDB
        .update(
            farmerId: int.parse(fId),
            address: address,
            aadharCardNo: aadharCard,
            mobileNumber: mobileNumber,
            noOfBuffalos: int.parse(numberOfBuffalo),
            noOfCows: int.parse(numberOfCows),
            modeOfPay: radio)
        .then((value) {
      Utils.showSnackbar("Farmer details updated..");
    });
    if (result) {
      Get.back();
      await updateFarmerApi().then((onValue) => Get.back());
    } else {
      Get.back();
    }
  }

  Future<void> updateFarmerApi() async {
    try {
      var res = await http.post(
        Uri.parse("$baseUrlConst/$updateFarmerDetailsConst"),
        body: {
          "FarmerID": fId.toString(),
          "CalculationsID": fId.toString(),
          "FarmerName": farmerName,
          "BankName": bankName.isNotEmpty ? bankName : "null",
          "BranchName": branchName.isNotEmpty ? branchName : "null",
          "AccountName": accountNumber.isNotEmpty ? accountNumber : "null",
          "IFSCCode": ifscCode.isNotEmpty ? ifscCode : "null",
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

      if (res.statusCode == 200) {}
      circularProgress = true;
    } catch (e) {
      // apiLopp(i);
      circularProgress = true;
    }
  }
}
