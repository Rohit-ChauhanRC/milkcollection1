import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:milkcollection/app/routes/app_pages.dart';
import 'package:milkcollection/app/utils/utils.dart';

class PinverifyController extends GetxController {
  //

  final box = GetStorage();

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

  final count = 0.obs;
  @override
  void onInit() {
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

  void increment() => count.value++;

  Future<dynamic> login() async {
    Utils.closeKeyboard();
    if (!loginFormKey.currentState!.validate()) {
      return null;
    }

    if (box.read("pin") == pin) {
      box.write("verify", true).then((value) {
        Get.offNamed(Routes.HOME);
      });
    } else {
      Utils.showDialog("Incorrect pin!");
    }
  }
}
