import 'package:get/get.dart';

class FarmerController extends GetxController {
  //

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

  final RxInt _radio = 1.obs;
  int get radio => _radio.value;
  set radio(int i) => _radio.value = i;

  @override
  void onInit() {
    super.onInit();
    type = Get.arguments[0];
    print("ggg${Get.arguments[0]}");
    if (Get.arguments[0] == true) {
      title = "Farmer Detail";
    } else {
      title = "Add Farmer";
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
