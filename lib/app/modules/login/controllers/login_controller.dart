import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:milkcollection/app/constants/contants.dart';
import 'package:milkcollection/app/data/models/login_model.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/utils.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  //
  GlobalKey<FormState> loginFormKey = GlobalKey();

  final box = GetStorage();

  final RxBool _circularProgress = true.obs;
  bool get circularProgress => _circularProgress.value;
  set circularProgress(bool v) => _circularProgress.value = v;

  final RxBool _check = false.obs;
  bool get check => _check.value;
  set check(bool v) => _check.value = v;

  final RxString _username = ''.obs;
  String get username => _username.value;
  set username(String mob) => _username.value = mob;

  final RxString _password = ''.obs;
  String get password => _password.value;
  set password(String mob) => _password.value = mob;

  final RxList<LoginModel> _loginModel = RxList<LoginModel>();
  List<LoginModel> get loginModel => _loginModel;
  set loginModel(List<LoginModel> lst) => _loginModel.assignAll(lst);

  @override
  void onInit() async {
    super.onInit();

    await Permission.storage.request();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<dynamic> login() async {
    Utils.closeKeyboard();
    if (!loginFormKey.currentState!.validate()) {
      return null;
    }

    await loginCred();
  }

  loginCred() async {
    circularProgress = false;
    try {
      var res = await http.get(
        Uri.parse(
            "$baseUrlConst/$loginConst?Username=$username&Password=$password"),
      );
      final a = jsonDecode(res.body);

      if (res.statusCode == 200) {
        loginModel.assignAll(loginModelFromMap(res.body));

        if (loginModel.isNotEmpty) {
          box.write(pinConst, loginModel[0].pin);
          box.write(centerIdConst, loginModel[0].centerId);
          box.write(centerName, loginModel[0].centerName);
          Get.toNamed(
            Routes.PINVERIFY,
          );
        } else {
          Utils.showDialog("Please check username and password!");
        }
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

  /*

    "OTP Sent !"

  "Login"


  "OutLet does not exists ?"

  "Franchisee does not exists ?"
  */
}
