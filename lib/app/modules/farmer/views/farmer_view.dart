import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:milkcollection/app/theme/app_colors.dart';
import 'package:milkcollection/app/widgets/backdround_container.dart';
import 'package:milkcollection/app/widgets/custom_button.dart';
import 'package:milkcollection/app/widgets/text_form_widget.dart';

import '../controllers/farmer_controller.dart';

class FarmerView extends GetView<FarmerController> {
  const FarmerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.title)),
        centerTitle: true,
      ),
      body: BackgroundContainer(
        child: Container(
          margin: const EdgeInsets.all(10),
          // color: Colors.amber,
          height: Get.height,
          child: Form(
            key: controller.farmerFormKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Famer Name:",
                    style: Theme.of(Get.context!).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Obx(() => SizedBox(
                      child: TextFormWidget(
                        // key: UniqueKey(),
                        readOnly: controller.type,
                        initialValue: controller.farmerName,
                        onChanged: (p0) => controller.farmerName = p0,
                        keyboardType: TextInputType.text,
                        validator: (val) =>
                            val!.length < 3 ? "Field is required!" : null,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bank Name:",
                    style: Theme.of(Get.context!).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Obx(() => SizedBox(
                      child: TextFormWidget(
                        // key: UniqueKey(),
                        readOnly: controller.type,
                        initialValue: controller.bankName,
                        onChanged: (p0) => controller.bankName = p0,
                        keyboardType: TextInputType.text,
                        validator: (val) =>
                            val!.length < 3 ? "Field is required!" : null,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Branch Name:",
                    style: Theme.of(Get.context!).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Obx(() => SizedBox(
                      child: TextFormWidget(
                        // key: UniqueKey(),

                        readOnly: controller.type,

                        initialValue: controller.branchName,
                        onChanged: (p0) => controller.branchName = p0,
                        keyboardType: TextInputType.text,
                        // maxLength: 10,
                        validator: (val) =>
                            val!.length < 3 ? "Field is required!" : null,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Account Number:",
                    style: Theme.of(Get.context!).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Obx(() => SizedBox(
                      child: TextFormWidget(
                        // key: UniqueKey(),

                        readOnly: controller.type,

                        initialValue: controller.accountNumber,
                        onChanged: (p0) => controller.accountNumber = p0,
                        keyboardType: TextInputType.text,
                        // maxLength: 10,
                        validator: (val) =>
                            val!.length < 3 ? "Field is required!" : null,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "IFSC Code:",
                    style: Theme.of(Get.context!).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Obx(() => SizedBox(
                      child: TextFormWidget(
                        // key: UniqueKey(),

                        readOnly: controller.type,

                        initialValue: controller.ifscCode,
                        onChanged: (p0) => controller.ifscCode = p0,
                        keyboardType: TextInputType.text,
                        // maxLength: 10,
                        validator: (val) =>
                            val!.length < 3 ? "Field is required!" : null,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Aadhar Card Number:",
                    style: Theme.of(Get.context!).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Obx(() => SizedBox(
                      child: TextFormWidget(
                        // key: UniqueKey(),

                        initialValue: controller.aadharCard,
                        onChanged: (p0) => controller.aadharCard = p0,
                        keyboardType: TextInputType.text,
                        // maxLength: 10,
                        validator: (val) =>
                            val!.length < 3 ? "Field is required!" : null,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mobile Number:",
                    style: Theme.of(Get.context!).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Obx(() => SizedBox(
                      child: TextFormWidget(
                        // key: UniqueKey(),

                        initialValue: controller.mobileNumber,
                        onChanged: (p0) => controller.mobileNumber = p0,
                        keyboardType: TextInputType.text,
                        // maxLength: 10,
                        validator: (val) =>
                            val!.length < 3 ? "Field is required!" : null,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Number of cows:",
                    style: Theme.of(Get.context!).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Obx(() => SizedBox(
                      child: TextFormWidget(
                        // key: UniqueKey(),

                        initialValue: controller.numberOfCows,
                        onChanged: (p0) => controller.numberOfCows = p0,
                        keyboardType: TextInputType.text,
                        // maxLength: 10,
                        validator: (val) =>
                            val!.length < 3 ? "Field is required!" : null,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Number of buffalo:",
                    style: Theme.of(Get.context!).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Obx(() => SizedBox(
                      child: TextFormWidget(
                        // key: UniqueKey(),

                        initialValue: controller.numberOfBuffalo,
                        onChanged: (p0) => controller.numberOfBuffalo = p0,
                        keyboardType: TextInputType.text,
                        // maxLength: 10,
                        validator: (val) =>
                            val!.length < 3 ? "Field is required!" : null,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Address:",
                    style: Theme.of(Get.context!).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Obx(() => SizedBox(
                      child: TextFormWidget(
                        // key: UniqueKey(),

                        initialValue: controller.address,
                        onChanged: (p0) => controller.address = p0,
                        keyboardType: TextInputType.text,
                        // maxLength: 10,
                        validator: (val) =>
                            val!.length < 3 ? "Field is required!" : null,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mode of Pay:",
                    style: Theme.of(Get.context!).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(() => SizedBox(
                              width: Get.width * 0.2,
                              child: Radio(
                                // key: UniqueKey(),
                                activeColor: AppColors.yellow,
                                value: 0,
                                groupValue: controller.radio,
                                onChanged: (int? i) {
                                  print(i);
                                  controller.radio = i!;
                                },
                              ),
                            )),
                        InkWell(
                          child: const Text("Cash"),
                          onTap: () {
                            controller.radio = 0;
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(() => SizedBox(
                              width: Get.width * 0.2,
                              child: Radio(
                                // key: UniqueKey(),
                                activeColor: AppColors.yellow,
                                value: 1,
                                groupValue: controller.radio,
                                onChanged: (int? i) {
                                  print(i);
                                  controller.radio = i!;
                                },
                              ),
                            )),
                        InkWell(
                          child: const Text("Bank"),
                          onTap: () {
                            controller.radio = 1;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                CustomButton(
                  onPressed: () async => controller.type
                      ? controller.localFarmerUpdate()
                      : controller.addFarmer(),
                  title: controller.type ? "Update" : "Save",
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
