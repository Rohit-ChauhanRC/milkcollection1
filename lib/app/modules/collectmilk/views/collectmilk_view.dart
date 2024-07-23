import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:milkcollection/app/constants/contants.dart';
import 'package:milkcollection/app/theme/app_colors.dart';
import 'package:milkcollection/app/utils/utils.dart';
import 'package:milkcollection/app/widgets/backdround_container.dart';
import 'package:milkcollection/app/widgets/decimal_nu.dart';
import 'package:milkcollection/app/widgets/text_form_widget.dart';

import '../controllers/collectmilk_controller.dart';

class CollectmilkView extends GetView<CollectmilkController> {
  const CollectmilkView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // controller.tt();
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
              bool result = await InternetConnection().hasInternetAccess;

              if (i == "Recover Data") {
                if (result) {
                  await controller.getRestoreData();
                } else {
                  Utils.showDialog("No Internet Connection available!");
                }
              } else if (i == "Manual Collection") {
                controller.pin = "";
                if (controller.box.read(manualpinConst) ==
                    DateFormat("yyyy-mm-dd")
                        .format(DateTime.now())
                        .toString()) {
                  controller.check = false;
                } else {
                  controller.showDialogManualPin(
                    initialValue: controller.pin,
                    onTap: () async {
                      await controller.getVerifyPin();
                    },
                  );
                }
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
                                controller.radio = 0;
                                controller.getRateCMChart();
                                if (double.parse(controller.homeController
                                                .quantity.isNotEmpty
                                            ? controller.homeController.quantity
                                            : "0") >
                                        0 ||
                                    double.parse(
                                            controller.quantityDC.isNotEmpty
                                                ? controller.quantityDC
                                                : "0") >
                                        0) {
                                  controller.getTotalAmount();
                                  controller.getPriceData();
                                }
                              },
                            ),
                          )),
                      InkWell(
                        child: const Text("Cow"),
                        onTap: () {
                          controller.radio = 0;
                          controller.getRateCMChart();
                          if (double.parse(controller
                                          .homeController.quantity.isNotEmpty
                                      ? controller.homeController.quantity
                                      : "0") >
                                  0 ||
                              double.parse(controller.quantityDC.isNotEmpty
                                      ? controller.quantityDC
                                      : "0") >
                                  0) {
                            controller.getTotalAmount();
                            controller.getPriceData();
                          }
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
                                controller.radio = 1;
                                controller.getRateBMChart();
                                // controller.getPriceData();
                                if (double.parse(controller.homeController
                                                .quantity.isNotEmpty
                                            ? controller.homeController.quantity
                                            : "0") >
                                        0 ||
                                    double.parse(
                                            controller.quantityDC.isNotEmpty
                                                ? controller.quantityDC
                                                : "0") >
                                        0) {
                                  controller.getTotalAmount();
                                  controller.getPriceData();
                                }
                              },
                            ),
                          )),
                      InkWell(
                        child: const Text("Buffallo"),
                        onTap: () {
                          controller.radio = 1;
                          controller.getRateBMChart();
                          // controller.getPriceData();
                          if (double.parse(controller
                                          .homeController.quantity.isNotEmpty
                                      ? controller.homeController.quantity
                                      : "0") >
                                  0 ||
                              double.parse(controller.quantityDC.isNotEmpty
                                      ? controller.quantityDC
                                      : "0") >
                                  0) {
                            controller.getTotalAmount();
                            controller.getPriceData();
                          }
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
                              child: TextFormWidget(
                                label: "Please enter fat...",
                                textController: controller.fat,
                                onChanged: (v) => controller.fatDC = v,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  DecimalTextInputFormatter(decimalRange: 1),
                                  LengthLimitingTextInputFormatter(3),
                                ],
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
                              width: Get.width * .3,
                              child: TextFormWidget(
                                label: "Please enter FarmerId...",
                                textController: controller.snf,
                                onChanged: (v) => controller.snfDC = v,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  DecimalTextInputFormatter(decimalRange: 1),
                                  LengthLimitingTextInputFormatter(3),
                                ],
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
                              width: Get.width * .3,
                              child: TextFormWidget(
                                readOnly: controller.check,
                                label: "Please enter FarmerId...",
                                textController: controller.water,
                                onChanged: (v) => controller.waterDC = v,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  DecimalTextInputFormatter(decimalRange: 1),
                                  // LengthLimitingTextInputFormatter(4),
                                ],
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
                              child: TextFormWidget(
                                readOnly: controller.check,
                                label: "Please enter fat...",
                                textController: controller.quantity,
                                onChanged: (v) => controller.quantityDC = v,
                                inputFormatters: [
                                  DecimalTextInputFormatter(decimalRange: 4),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"[0-9.]")),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d*')),
                                ],
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true, signed: false),
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
                                          (controller.radio == 1 ||
                                              controller.radio == 0)
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
                                  controller.fatDC.isNotEmpty &&
                                          controller.snfDC.isNotEmpty &&
                                          (controller.radio == 1 ||
                                              controller.radio == 0)
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
                      Container(
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
                        child: Obx(() => Text(
                              (double.parse(controller.homeController.quantity
                                                      .isNotEmpty
                                                  ? controller
                                                      .homeController.quantity
                                                  : "0") >
                                              0 ||
                                          double.parse(controller
                                                      .quantityDC.isNotEmpty
                                                  ? controller.quantityDC
                                                  : "0") >
                                              0) &&
                                      (controller.radio == 1 ||
                                          controller.radio == 0)
                                  ? controller.getTotalAmount()
                                  : "",
                              style: Theme.of(context).textTheme.labelMedium,
                              textAlign: TextAlign.center,
                            )),
                      )

                      // ),
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
                          ? Obx(() => ElevatedButton(
                                onPressed: () async {
                                  bool result = await InternetConnection()
                                      .hasInternetAccess;

                                  if (controller.farmerId.isNotEmpty &&
                                      controller
                                          .homeController.fat.isNotEmpty &&
                                      controller.farmerData.farmerName !=
                                          "Unknown" &&
                                      controller
                                          .homeController.water.isNotEmpty &&
                                      controller
                                          .homeController.quantity.isNotEmpty &&
                                      (controller.radio == 1 ||
                                          controller.radio == 0) &&
                                      (double.parse(controller.getPriceData()) >
                                          0)) {
                                    if (double.parse(controller
                                            .homeController.quantity) >
                                        0) {
                                      controller.progress = true;
                                      await controller.accept();
                                      await controller.printData();
                                      await controller.homeController
                                          .fetchMilkCollectionDateWise();

                                      if (result) {
                                        await controller.sendCollection();
                                        await controller.checkSmsFlag();
                                      }

                                      controller.emptyData();
                                      controller.progress = false;
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: (controller
                                                  .farmerId.isNotEmpty &&
                                              (controller.homeController.fat
                                                  .isNotEmpty) &&
                                              controller.farmerData.farmerName !=
                                                  "Unknown" &&
                                              (controller.homeController.water
                                                  .isNotEmpty) &&
                                              (controller.homeController
                                                  .quantity.isNotEmpty)) &&
                                          (controller.radio == 1 ||
                                              controller.radio == 0) &&
                                          (double.parse(
                                                  controller.getPriceData()) >
                                              0)
                                      ? double.parse(controller
                                                  .homeController.quantity) >
                                              0
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
                              ))
                          : ElevatedButton(
                              onPressed: () async {
                                bool result = await InternetConnection()
                                    .hasInternetAccess;

                                if (controller.farmerId.isNotEmpty &&
                                    controller.fatDC.isNotEmpty &&
                                    controller.farmerData.farmerName !=
                                        "Unknown" &&
                                    controller.waterDC.isNotEmpty &&
                                    controller.quantityDC.isNotEmpty &&
                                    controller.snfDC.isNotEmpty &&
                                    (controller.radio == 1 ||
                                        controller.radio == 0) &&
                                    (double.parse(controller.getPriceData()) >
                                        0)) {
                                  if (double.parse(controller.quantityDC) > 0) {
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
                                            (controller.fatDC.isNotEmpty) &&
                                            controller.farmerData.farmerName !=
                                                "Unknown" &&
                                            (controller.waterDC.isNotEmpty) &&
                                            (controller
                                                .quantityDC.isNotEmpty) &&
                                            controller.snfDC.isNotEmpty) &&
                                        (controller.radio == 1 ||
                                            controller.radio == 0) &&
                                        (double.parse(
                                                controller.getPriceData()) >
                                            0)
                                    ? double.parse(controller.quantityDC) > 0 &&
                                            controller.farmerIdC.text.isNotEmpty
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
                          // if (controller.farmerId.isNotEmpty &&
                          //     (controller.fat.text.isNotEmpty ||
                          //         controller.homeController.fat.isNotEmpty) &&
                          //     controller.farmerData.farmerName != "Unknown") {
                          controller.emptyData();
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
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
                  ),
                )),
          ],
        ),
      ],
    );
  }
}
