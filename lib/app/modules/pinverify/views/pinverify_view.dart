import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';

import '../../../widgets/backdround_container.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/text_form_widget.dart';
import '../controllers/pinverify_controller.dart';

class PinverifyView extends GetView<PinverifyController> {
  const PinverifyView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UpgradeAlert(
        dialogStyle: UpgradeDialogStyle.cupertino,
        showIgnore: false,
        showLater: false,
        showReleaseNotes: true,
        upgrader: Upgrader(),
        child: SingleChildScrollView(
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
                  height: 30.h,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 35),
                  width: Get.width,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Mak Life Dairy Producer Company Limited",
                      overflow: TextOverflow.visible,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.h, left: 35.w, right: 35.w),
                  child: Form(
                    key: controller.loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Enter Pin:",
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
                                  Icons.pin,
                                  size: 30,
                                ),
                                initialValue: controller.pin,
                                label: "Please enter Pin...",
                                onChanged: (val) => controller.pin = val,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  signed: true,
                                ),
                                validator: (val) => val!.length < 3
                                    ? "Field is required!"
                                    : null,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Obx(() => controller.circularProgress
                    ? Container(
                        width: Get.width,
                        // padding: const EdgeInsets.all(20),
                        margin:
                            EdgeInsets.only(top: 15.h, left: 35.w, right: 35.w),
                        child: CustomButton(
                          onPressed: () {
                            // Get.toNamed(Routes.HOME, arguments: ["O", "9711784343"]);
                            // if (controller.check) {
                            controller.login();
                            // }
                          },
                          title: "Login",
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      )),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  width: Get.width,
                  // padding: const EdgeInsets.all(20),
                  margin: EdgeInsets.only(top: 15.h, left: 35.w, right: 35.w),
                  child: CustomButton(
                    onPressed: () {
                      // Get.offNamed(Routes.HOME);
                    },
                    title: "Upload",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => Text("Version: ${controller.version}" ?? "")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
