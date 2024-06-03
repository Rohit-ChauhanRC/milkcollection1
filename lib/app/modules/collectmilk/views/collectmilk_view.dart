import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:milkcollection/app/theme/app_colors.dart';
import 'package:milkcollection/app/widgets/backdround_container.dart';
import 'package:milkcollection/app/widgets/decimal_nu.dart';
import 'package:milkcollection/app/widgets/text_form_widget.dart';

import '../controllers/collectmilk_controller.dart';
import 'package:flutter/services.dart';

class CollectmilkView extends GetView<CollectmilkController> {
  const CollectmilkView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // controller.getRateChart();
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
                          controller.farmerId.isNotEmpty
                              ? controller.farmerData.farmerName.toString()
                              : "",
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
                                controller.getRateChart();
                              },
                            ),
                          )),
                      InkWell(
                        child: const Text("Cow"),
                        onTap: () {
                          controller.radio = 0;
                          controller.getRateChart();
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
                                controller.getRateChart();
                                controller.getPriceData();
                                controller.getTotalAmount();
                              },
                            ),
                          )),
                      InkWell(
                        child: const Text("Buffallo"),
                        onTap: () {
                          controller.radio = 1;
                          controller.getRateChart();
                          controller.getPriceData();
                          controller.getTotalAmount();
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
                          controller.farmerId.toString().isNotEmpty
                              ? controller.getFarmerIdFinal()
                              : "",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
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
                  // initialValue: controller.farmerId,
                  label: "Please enter FarmerId...",
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textController: controller.farmerIdC,
                  onChanged: (val) {
                    controller.farmerId = val;
                    if (controller.farmerId.trim().isNotEmpty) {
                      controller.getFarmerId();
                    }
                  },
                  // keyboardType:
                  //     const TextInputType.numberWithOptions(signed: true),
                  maxLength: 4,
                  // validator: (val) =>
                  //     val!.length < 1 ? "Field is required!" : null,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
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
                                "${controller.homeController.fat.isNotEmpty ? double.tryParse(controller.homeController.fat)!.toPrecision(1) : ""}",
                                style: Theme.of(context).textTheme.labelMedium,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : SizedBox(
                              width: Get.width * .3,
                              // height: 65.h,
                              child: TextFormWidget(
                                label: "Please enter fat...",
                                textController: controller.fat,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),

                                onChanged: (e) async {
                                  // controller.fat.text = e;
                                  // await controller.getRateChart();
                                },
                                inputFormatters: [
                                  DecimalTextInputFormatter(decimalRange: 1),
                                ],
                                // onChanged: (e)=> controller.homeController.fat = controller.f,
                                // keyboardType: TextInputType.text,
                                maxLength: 3,
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
                                "${controller.homeController.snf.isNotEmpty ? double.tryParse(controller.homeController.snf)!.toPrecision(1) : ""}",
                                style: Theme.of(context).textTheme.labelMedium,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : SizedBox(
                              // width: 100.w,
                              width: Get.width * .3,

                              // height: 65.h,
                              child: TextFormWidget(
                                // readOnly: controller.check,
                                // initialValue: controller.snf.text,
                                label: "Please enter FarmerId...",
                                // onChanged: onChanged2,
                                textController: controller.snf,
                                // onChanged: (e) => controller.snf = e,

                                // keyboardType: TextInputType.text,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  DecimalTextInputFormatter(decimalRange: 1),
                                  // FilteringTextInputFormatter.digitsOnly,
                                ],
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
                                controller.homeController.water ?? "",
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
                                // initialValue: controller.water.text,
                                label: "Please enter FarmerId...",
                                // onChanged: onChanged3,
                                // onChanged: (e) {
                                textController: controller.water,
                                // },

                                // keyboardType: TextInputType.text,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  DecimalTextInputFormatter(decimalRange: 1),
                                ],
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
                                controller.homeController.fat.isNotEmpty
                                    ? controller.homeController.quantity
                                    : "",
                                style: Theme.of(context).textTheme.labelMedium,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : SizedBox(
                              width: Get.width * .3,
                              // height: 65.h,
                              child: TextFormWidget(
                                readOnly: controller.check,
                                // initialValue: controller.quantity.text,
                                label: "Please enter fat...",
                                textController: controller.quantity,
                                onChanged: (e) {
                                  // controller.quantity = e;
                                  // controller.getPriceData();
                                  // controller.getTotalAmount();
                                },
                                // keyboardType: TextInputType.text,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true, signed: false),
                                inputFormatters: [
                                  // DecimalTextInputFormatter(decimalRange: 1),
                                ],
                                // inputFormatters: [
                                //   FilteringTextInputFormatter.digitsOnly,
                                // ],
                                // maxLength: 3,
                              ),
                            )),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
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
                      Obx(
                        () => controller.check
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
                                  controller.homeController.fat.isNotEmpty &&
                                          controller
                                              .homeController.snf.isNotEmpty
                                      ? controller.getPriceData()
                                      : "",
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container(
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
                                  controller.fat.text.isNotEmpty &&
                                          controller.snf.text.isNotEmpty
                                      ? controller.getPriceData()
                                      : "",
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ),
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
                      Obx(
                        () => controller.check
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
                                  controller.homeController.fat.isNotEmpty &&
                                          controller
                                              .homeController.snf.isNotEmpty &&
                                          controller.homeController.quantity
                                              .isNotEmpty
                                      ? controller.getTotalAmount()
                                      : "",
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container(
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
                                  controller.fat.text.isNotEmpty &&
                                          controller.snf.text.isNotEmpty &&
                                          controller.quantity.text.isNotEmpty
                                      ? controller.getTotalAmount()
                                      : "",
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ),
                    ],
                  ),
                  // ],
                  // ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Obx(() => !controller.progress
                  ? Container(
                      width: Get.width,
                      // padding: const EdgeInsets.all(20),
                      margin:
                          EdgeInsets.only(top: 15.h, left: 35.w, right: 35.w),
                      child: controller.check
                          ? ElevatedButton(
                              onPressed: () async {
                                bool result = await InternetConnection()
                                    .hasInternetAccess;

                                if (controller.farmerId.isNotEmpty &&
                                    controller.homeController.fat.isNotEmpty &&
                                    controller.farmerData.farmerName !=
                                        "Unknown" &&
                                    controller
                                        .homeController.water.isNotEmpty &&
                                    controller
                                        .homeController.quantity.isNotEmpty) {
                                  if (double.parse(
                                              controller.homeController.fat) <=
                                          10 &&
                                      double.parse(
                                              controller.homeController.snf) <=
                                          10) {
                                    controller.progress = true;
                                    await controller.accept();
                                    await controller.printData();
                                    if (result) {
                                      await controller.sendCollection();
                                      await controller.checkSmsFlag();
                                      await controller.homeController
                                          .fetchMilkCollectionDateWise();
                                    }

                                    controller.emptyData();
                                    controller.progress = false;
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: (controller
                                            .farmerId.isNotEmpty &&
                                        (controller
                                            .homeController.fat.isNotEmpty) &&
                                        controller.farmerData.farmerName !=
                                            "Unknown" &&
                                        (controller
                                            .homeController.water.isNotEmpty) &&
                                        (controller.homeController.quantity
                                            .isNotEmpty))
                                    ? (double.parse(controller
                                                    .homeController.fat) <=
                                                10 &&
                                            double.parse(controller
                                                    .homeController.snf) <=
                                                10)
                                        ? AppColors.green
                                        : const Color.fromARGB(
                                            255, 211, 240, 212)
                                    : const Color.fromARGB(255, 211, 240, 212),
                              ),
                              child: Text(
                                "ACCEPT",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: AppColors.white),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                bool result = await InternetConnection()
                                    .hasInternetAccess;

                                if (controller.farmerId.isNotEmpty &&
                                    controller.fat.text.isNotEmpty &&
                                    controller.farmerData.farmerName !=
                                        "Unknown" &&
                                    controller.water.text.isNotEmpty &&
                                    controller.quantity.text.isNotEmpty &&
                                    controller.totalAmount.isNotEmpty) {
                                  if (double.parse(controller.fat.text) <= 10 &&
                                      double.parse(controller.snf.text) <= 10) {
                                    controller.progress = true;
                                    await controller.accept();
                                    await controller.printData();

                                    if (result) {
                                      await controller.sendCollection();
                                      await controller.checkSmsFlag();
                                      await controller.homeController
                                          .fetchMilkCollectionDateWise();
                                    }
                                    controller.emptyData();
                                    controller.progress = false;
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: (controller
                                            .farmerId.isNotEmpty &&
                                        (controller.fat.text.isNotEmpty) &&
                                        controller.farmerData.farmerName !=
                                            "Unknown" &&
                                        (controller.water.text.isNotEmpty) &&
                                        (controller.quantity.text.isNotEmpty) &&
                                        controller.totalAmount.isNotEmpty)
                                    ? (double.parse(controller.fat.text) <=
                                                10 &&
                                            double.parse(controller.snf.text) <=
                                                10)
                                        ? AppColors.green
                                        : const Color.fromARGB(
                                            255, 211, 240, 212)
                                    : const Color.fromARGB(255, 211, 240, 212),
                              ),
                              child: Text(
                                "ACCEPT",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: AppColors.white),
                              ),
                            ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    )),
              SizedBox(
                height: 20.h,
              ),
              Obx(() => !controller.progress
                  ? Container(
                      width: Get.width,
                      // padding: const EdgeInsets.all(20),
                      margin:
                          EdgeInsets.only(top: 15.h, left: 35.w, right: 35.w),
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.farmerId.isNotEmpty &&
                              (controller.fat.text.isNotEmpty ||
                                  controller.homeController.fat.isNotEmpty) &&
                              controller.farmerData.farmerName != "Unknown" &&
                              controller.totalAmount.isNotEmpty) {
                            controller.emptyData();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (controller.farmerId.isNotEmpty &&
                                  (controller.fat.text.isNotEmpty ||
                                      controller
                                          .homeController.fat.isNotEmpty) &&
                                  controller.farmerData.farmerName != "Unknown")
                              ? AppColors.red
                              : const Color.fromARGB(255, 247, 170, 165),
                        ),
                        child: Text(
                          "REJECT",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(color: AppColors.white),
                        ),
                      ),
                    )
                  : const SizedBox()),
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
