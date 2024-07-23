import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';

import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimens.dart';
import '../../../widgets/backdround_container.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/text_form_widget.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: BackgroundContainer(
          child: Column(
            children: [
              Container(
                height: 150.h,
                width: 200.w,
                margin: EdgeInsets.only(top: 100.h),
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.fill,
                  // height: Get.height * 0.5,
                  alignment: Alignment.topCenter,
                  scale: 1,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                margin: EdgeInsets.only(top: 10.h, left: 35.w, right: 35.w),
                child: Form(
                  key: controller.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Username:",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Obx(() => SizedBox(
                            // width: Get.width * 0.7,
                            // height: 65.h,
                            child: TextFormWidget(
                              prefix: const Icon(
                                Icons.person_4_sharp,
                                size: 30,
                              ),
                              initialValue: controller.username,
                              label: "Please enter Username...",
                              onChanged: (val) => controller.username = val,
                              keyboardType: TextInputType.text,
                              validator: (val) =>
                                  val!.length < 3 ? "Field is required!" : null,
                            ),
                          )),
                      SizedBox(
                        height: 20.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Password:",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Obx(() => SizedBox(
                            // width: Get.width * 0.7,
                            // height: 65.h,
                            child: TextFormWidget(
                              prefix: const Icon(
                                Icons.remove_red_eye,
                                size: 30,
                              ),
                              obscureText: true,
                              initialValue: controller.password,
                              label: "Please enter Password...",
                              onChanged: (val) => controller.password = val,
                              keyboardType: TextInputType.text,
                              validator: (val) =>
                                  val!.length < 3 ? "Field is required!" : null,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                width: Get.width,
                // padding: const EdgeInsets.all(20),
                margin: EdgeInsets.only(top: 15.h, left: 35.w, right: 35.w),
                child: CustomButton(
                  onPressed: () {
                    controller.login();
                  },
                  title: "Login",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
