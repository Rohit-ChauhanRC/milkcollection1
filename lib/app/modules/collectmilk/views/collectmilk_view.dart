import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:milkcollection/app/modules/home/controllers/home_controller.dart';
import 'package:milkcollection/app/theme/app_colors.dart';
import 'package:milkcollection/app/utils/utils.dart';
import 'package:milkcollection/app/widgets/backdround_container.dart';
import 'package:milkcollection/app/widgets/custom_button.dart';
import 'package:milkcollection/app/widgets/text_form_widget.dart';

import '../controllers/collectmilk_controller.dart';

class CollectmilkView extends GetView<CollectmilkController> {
  const CollectmilkView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maklife'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "Manual Collection",
                child: Text("Manual Collection"),
              ),
              const PopupMenuItem(
                value: "Recover Data",
                child: Text("Recover Data"),
              ),
              const PopupMenuItem(
                value: "Export Excel",
                child: Text("Export Excel"),
              ),
            ],
            elevation: 2,
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.white,
            ),
            onSelected: (String i) async {
              print(i);
              if (i == "Recover Data") {
                await controller.getRestoreData();
              } else if (i == "Manual Collection") {
                controller.pin = "";
                controller.showDialogManualPin(
                  initialValue: controller.pin,
                  onTap: () async {
                    await controller.getVerifyPin();
                  },
                );
                // await controller.getVerifyPin();
              } else {
                await controller.exportExcel();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: BackgroundContainer(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Name:",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Obx(() => Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          controller.farmerData.farmerName ?? "",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )),
                ],
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
                              value: 0,
                              groupValue: controller.radio,
                              onChanged: (int? i) {
                                print(i);
                                controller.radio = i!;
                              },
                            ),
                          )),
                      InkWell(
                        child: const Text("Cow"),
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
                        child: const Text("Buffallo"),
                        onTap: () {
                          controller.radio = 1;
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "FarmerId:",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Obx(() => Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${controller.farmerData.farmerId ?? ""}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Obx(() => SizedBox(
                    // width: Get.width * 0.7,
                    // height: 65.h,
                    child: TextFormWidget(
                      // readOnly: controller.check,
                      prefix: InkWell(
                        onTap: () {
                          if (controller.farmerId.trim().isNotEmpty) {
                            controller.getFarmerId();
                          }
                        },
                        child: const Icon(
                          Icons.search,
                          size: 30,
                        ),
                      ),
                      initialValue: controller.farmerId,
                      label: "Please enter FarmerId...",
                      onChanged: (val) {
                        controller.farmerId = val;
                        if (controller.farmerId.trim().isNotEmpty) {
                          controller.getFarmerId();
                        }
                      },
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: true),
                      maxLength: 10,
                      // validator: (val) =>
                      //     val!.length < 1 ? "Field is required!" : null,
                    ),
                  )),
              SizedBox(
                height: 20.h,
              ),
              // GetBuilder<HomeController>(builder: (
              //   HomeController homeController,
              // ) {
              //   return datafieldcontainer(
              //     onChanged1: (p0) {},
              //     onChanged2: (p0) {},
              //     onChanged3: (p0) {},
              //     title1: "FAT",
              //     title2: "SNF",
              //     title3: "WATER",
              //     initialValue1: homeController.fat,
              //     initialValue2: homeController.snf,
              //     initialValue3: homeController.water,
              //   );
              // }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "FAT",
                          style: Theme.of(Get.context!).textTheme.bodySmall,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Obx(() => controller.check
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: AppColors.black,
                                  // width: 2,
                                ),
                                color: AppColors.white,
                              ),
                              width: Get.width * .3,
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                "${double.tryParse(controller.fat)!.toPrecision(1)}",
                                style: Theme.of(context).textTheme.labelMedium,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : SizedBox(
                              width: Get.width * .3,
                              // height: 65.h,
                              child: TextFormWidget(
                                readOnly: controller.check,
                                initialValue: controller.fat,
                                label: "Please enter fat...",
                                onChanged: (e) =>
                                    controller.fat = controller.fat,

                                // onChanged: (e)=> controller.homeController.fat = controller.f,
                                keyboardType: TextInputType.text,
                                maxLength: 10,
                              ),
                            )),
                    ],
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "SNF",
                          style: Theme.of(Get.context!).textTheme.bodySmall,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Obx(() => controller.check
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: AppColors.black,
                                  // width: 2,
                                ),
                                color: AppColors.white,
                              ),
                              width: Get.width * .3,
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                "${double.tryParse(controller.snf)!.toPrecision(1)}",
                                style: Theme.of(context).textTheme.labelMedium,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : SizedBox(
                              // width: 100.w,
                              width: Get.width * .3,

                              // height: 65.h,
                              child: TextFormWidget(
                                readOnly: controller.check,
                                initialValue: controller.snf,
                                label: "Please enter FarmerId...",
                                // onChanged: onChanged2,
                                onChanged: (e) =>
                                    controller.snf = controller.snf,

                                keyboardType: TextInputType.text,
                                maxLength: 10,
                              ),
                            )),
                    ],
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "WATER",
                          style: Theme.of(Get.context!).textTheme.bodySmall,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Obx(() => controller.check
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: AppColors.black,
                                  // width: 2,
                                ),
                                color: AppColors.white,
                              ),
                              width: Get.width * .3,
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                controller.water,
                                style: Theme.of(context).textTheme.labelMedium,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : SizedBox(
                              // width: 100.w,
                              width: Get.width * .3,

                              // height: 65.h,
                              child: TextFormWidget(
                                readOnly: controller.check,
                                initialValue: controller.water,
                                label: "Please enter FarmerId...",
                                // onChanged: onChanged3,
                                onChanged: (e) =>
                                    controller.water = controller.water,

                                keyboardType: TextInputType.text,
                                maxLength: 10,
                              ),
                            )),
                    ],
                  ),
                ],
              ),

              SizedBox(
                height: 20.h,
              ),
              // Obx(() => datafieldcontainer(
              //       onChanged1: (p0) {},
              //       onChanged2: (p0) {},
              //       onChanged3: (p0) {},
              //       title1: "QUANTITY",
              //       title2: "PRICE",
              //       title3: "AMOUNT",
              //       initialValue1: controller.fat,
              //       initialValue2: controller.snf,
              //       initialValue3: controller.water,
              //     )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "QUANTITY",
                          style: Theme.of(Get.context!).textTheme.bodySmall,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Obx(() => controller.check
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: AppColors.black,
                                  // width: 2,
                                ),
                                color: AppColors.white,
                              ),
                              width: Get.width * .3,
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                controller.quantity,
                                style: Theme.of(context).textTheme.labelMedium,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : SizedBox(
                              width: Get.width * .3,
                              // height: 65.h,
                              child: TextFormWidget(
                                readOnly: controller.check,
                                initialValue: controller.fat,
                                label: "Please enter fat...",
                                onChanged: (e) =>
                                    controller.quantity = controller.quantity,
                                keyboardType: TextInputType.text,
                                maxLength: 10,
                              ),
                            )),
                    ],
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "PRICE",
                          style: Theme.of(Get.context!).textTheme.bodySmall,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Obx(() => SizedBox(
                            // width: 100.w,
                            width: Get.width * .3,

                            // height: 65.h,
                            child: TextFormWidget(
                              readOnly: controller.check,
                              initialValue: controller.snf,
                              label: "Please enter FarmerId...",
                              // onChanged: onChanged2,
                              onChanged: (e) => controller.fat = controller.fat,

                              keyboardType: TextInputType.text,
                              maxLength: 10,
                            ),
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "AMOUNT",
                          style: Theme.of(Get.context!).textTheme.bodySmall,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Obx(() => SizedBox(
                            // width: 100.w,
                            width: Get.width * .3,

                            // height: 65.h,
                            child: TextFormWidget(
                              readOnly: controller.check,
                              initialValue: controller.water,
                              label: "Please enter FarmerId...",
                              // onChanged: onChanged3,
                              onChanged: (e) => controller.fat = controller.fat,

                              keyboardType: TextInputType.text,
                              maxLength: 10,
                            ),
                          )),
                    ],
                  ),
                ],
              ),

              SizedBox(
                height: 20.h,
              ),

              Container(
                width: Get.width,
                // padding: const EdgeInsets.all(20),
                margin: EdgeInsets.only(top: 15.h, left: 35.w, right: 35.w),
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.getRestoreData();
                  },
                  child: Text("ACCEPT"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                  ),
                ),
              ),

              // CustomButton(
              //   title: "ACCEPT",
              //   onPressed: () {},
              // ),
              // Obx(() => Text("Weight: ${controller.quantity}")),
              SizedBox(
                height: 20.h,
              ),
              Container(
                width: Get.width,
                // padding: const EdgeInsets.all(20),
                margin: EdgeInsets.only(top: 15.h, left: 35.w, right: 35.w),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("REJECT"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget datafieldcontainer({
    required String title1,
    required String title2,
    required String title3,
    required String initialValue1,
    required String initialValue2,
    required String initialValue3,
    required Function(String)? onChanged1,
    required Function(String)? onChanged2,
    required Function(String)? onChanged3,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title1,
                style: Theme.of(Get.context!).textTheme.bodySmall,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Obx(() => SizedBox(
                  width: Get.width * .3,
                  // height: 65.h,
                  child: TextFormWidget(
                    readOnly: controller.check,
                    initialValue: initialValue1,
                    label: "Please enter FarmerId...",
                    onChanged: onChanged1,
                    keyboardType: TextInputType.text,
                    maxLength: 10,
                  ),
                )),
          ],
        ),
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title2,
                style: Theme.of(Get.context!).textTheme.bodySmall,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Obx(() => SizedBox(
                  // width: 100.w,
                  width: Get.width * .3,

                  // height: 65.h,
                  child: TextFormWidget(
                    readOnly: controller.check,
                    initialValue: initialValue2,
                    label: "Please enter FarmerId...",
                    onChanged: onChanged2,
                    keyboardType: TextInputType.text,
                    maxLength: 10,
                  ),
                )),
          ],
        ),
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title3,
                style: Theme.of(Get.context!).textTheme.bodySmall,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Obx(() => SizedBox(
                  // width: 100.w,
                  width: Get.width * .3,

                  // height: 65.h,
                  child: TextFormWidget(
                    readOnly: controller.check,
                    initialValue: initialValue3,
                    label: "Please enter FarmerId...",
                    onChanged: onChanged3,
                    keyboardType: TextInputType.text,
                    maxLength: 10,
                  ),
                )),
          ],
        ),
      ],
    );
  }
}
