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
      body: SingleChildScrollView(
        child: BackgroundContainer(
          child: Container(
            margin: const EdgeInsets.all(10),
            // color: Colors.amber,
            height: Get.height,
            child: ListView(
              shrinkWrap: true,
              children: [
                Obx(() => textFieldColumn(
                      onChanged: (p0) => controller.farmerName = p0,
                      title: "Famer Name:",
                      initialValue: controller.farmerName,
                      validator: (val) =>
                          val!.length < 3 ? "Field is required!" : null,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => textFieldColumn(
                      onChanged: (p0) => controller.bankName = p0,
                      title: "Bank Name:",
                      initialValue: controller.bankName,
                      validator: (val) =>
                          val!.length < 3 ? "Field is required!" : null,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => textFieldColumn(
                      onChanged: (p0) => controller.branchName = p0,
                      title: "Branch Name:",
                      initialValue: controller.branchName,
                      validator: (val) =>
                          val!.length < 3 ? "Field is required!" : null,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => textFieldColumn(
                      onChanged: (p0) => controller.accountNumber = p0,
                      title: "Account Number:",
                      initialValue: controller.accountNumber,
                      validator: (val) =>
                          val!.length < 3 ? "Field is required!" : null,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => textFieldColumn(
                      onChanged: (p0) => controller.ifscCode = p0,
                      title: "IFSC Code:",
                      initialValue: controller.ifscCode,
                      validator: (val) =>
                          val!.length < 3 ? "Field is required!" : null,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => textFieldColumn(
                      onChanged: (p0) => controller.aadharCard = p0,
                      title: "Aadhar Card Number:",
                      initialValue: controller.aadharCard,
                      validator: (val) =>
                          val!.length < 3 ? "Field is required!" : null,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => textFieldColumn(
                      onChanged: (p0) => controller.mobileNumber = p0,
                      title: "Mobile Number:",
                      initialValue: controller.mobileNumber,
                      validator: (val) =>
                          val!.length < 3 ? "Field is required!" : null,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => textFieldColumn(
                      onChanged: (p0) => controller.numberOfCows = p0,
                      title: "Number of cows:",
                      initialValue: controller.numberOfCows,
                      validator: (val) =>
                          val!.length < 1 ? "Field is required!" : null,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => textFieldColumn(
                      onChanged: (p0) => controller.numberOfBuffalo = p0,
                      title: "Number of buffalo:",
                      initialValue: controller.numberOfBuffalo,
                      validator: (val) =>
                          val!.length < 1 ? "Field is required!" : null,
                    )),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => textFieldColumn(
                      onChanged: (p0) => controller.address = p0,
                      title: "Address:",
                      initialValue: controller.address,
                      validator: (val) =>
                          val!.length < 3 ? "Field is required!" : null,
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
                          child: const Text("Cash"),
                          onTap: () {
                            controller.radio = 1;
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
                                activeColor: AppColors.yellow,
                                value: 2,
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
                            controller.radio = 2;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                CustomButton(
                  onPressed: () {},
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

  Widget textFieldColumn({
    required String title,
    required Function(String)? onChanged,
    String? initialValue,
    String? Function(String?)? validator,
  }) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: Theme.of(Get.context!).textTheme.bodyMedium,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          // width: Get.width * 0.7,
          // height: 65.h,
          child: TextFormWidget(
            initialValue: initialValue,
            onChanged: onChanged,
            keyboardType: TextInputType.text,
            maxLength: 10,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
