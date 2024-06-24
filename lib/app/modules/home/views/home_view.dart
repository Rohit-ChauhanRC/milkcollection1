import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:milkcollection/app/constants/contants.dart';
import 'package:milkcollection/app/routes/app_pages.dart';
import 'package:milkcollection/app/theme/app_colors.dart';

import '../../../widgets/backdround_container.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Maklife CenterId (${controller.box.read(centerIdConst)}) "),
        automaticallyImplyLeading: false,
      ),
      body: BackgroundContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 5, left: 20, right: 20, bottom: 5),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                        ).then((selectedDate) async {
                          controller.fromDate = selectedDate!.toIso8601String();
                          print(controller.fromDate);

                          await controller.fetchMilkCollectionDateWise();
                        });
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.white,
                          ),
                          Obx(() => Text(
                                DateFormat("dd-MMM-yyyy").format(
                                    DateTime.parse(controller.fromDate)),
                                style: Theme.of(context).textTheme.bodySmall,
                              )),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(() => SizedBox(
                              width: Get.width * 0.18,
                              child: Radio(
                                activeColor: AppColors.yellow,
                                value: 1,
                                groupValue: controller.radio,
                                onChanged: (int? i) {
                                  print(i);
                                  controller.radio = i!;
                                  controller.fetchMilkCollectionDateWise();
                                },
                              ),
                            )),
                        InkWell(
                          child: Text(
                            "AM",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
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
                              width: Get.width * 0.18,
                              child: Radio(
                                activeColor: AppColors.yellow,
                                value: 2,
                                groupValue: controller.radio,
                                onChanged: (int? i) {
                                  print(i);
                                  controller.radio = i!;
                                  controller.fetchMilkCollectionDateWise();
                                },
                              ),
                            )),
                        InkWell(
                          child: Text(
                            "PM",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          onTap: () {
                            controller.radio = 2;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    // color: AppColors.brown,
                    border: Border.all(
                  color: AppColors.white,
                  width: 2,
                )),
                child: Column(
                  children: [
                    Obx(() => Container(
                          // margin: const EdgeInsets.all(15),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              intrinsicWidget(
                                  title1: "Tot. Milk",
                                  value1: controller.totalMilk >= 1.0
                                      ? controller.totalMilk.toString()
                                      : "0.0",
                                  title2: "Avg Fat",
                                  value2: controller.totalFat >= 1.0 &&
                                          controller.totalQty >= 1
                                      ? (controller.totalFat /
                                              controller.totalMilk)
                                          .toPrecision(2)
                                          .toString()
                                      : "0.0",
                                  title3: "Avg SNF",
                                  value3: controller.totalQty >= 1 &&
                                          controller.totalSnf >= 1.0
                                      ? (controller.totalSnf /
                                              controller.totalMilk)
                                          .toPrecision(2)
                                          .toString()
                                      : "0.0"),
                            ],
                          ),
                        )),
                    const Divider(
                      color: AppColors.white,
                      thickness: 2,
                    ),
                    Obx(() => Container(
                          // margin: const EdgeInsets.all(15),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              intrinsicWidget(
                                  title1: "Avg Water",
                                  value1: controller.totalQty >= 1.0 &&
                                          controller.totalQty >= 1
                                      ? (controller.totalWater /
                                              controller.totalQty)
                                          .toPrecision(2)
                                          .toString()
                                      : "0.0",
                                  title2: "Avg Price",
                                  value2: controller.totalPrice >= 1.0
                                      ? (controller.totalPrice /
                                              controller.totalQty)
                                          .toPrecision(2)
                                          .toString()
                                      : "0.0",
                                  title3: "Tot. Amt",
                                  value3: controller.totalAmt >= 1.0
                                      ? controller.totalAmt
                                          .toPrecision(2)
                                          .toString()
                                      : "0.0"),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                // margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.button.withOpacity(0.3),
                  // borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.card,
                  ),
                ),
                child: cardWidget(),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() => controller.milkCollectionData.isNotEmpty
                  ? Container(
                      height: Get.height * 0.35,
                      child: ListView.builder(
                          itemCount: controller.milkCollectionData.length,
                          itemBuilder: (ctx, i) {
                            return collectionTable(
                              amtV: controller.milkCollectionData[i].totalAmt
                                  .toString(),
                              fId: controller.milkCollectionData[i].farmerId
                                  .toString(),
                              fNmae: controller.milkCollectionData[i].farmerName
                                  .toString(),
                              fatV: controller.milkCollectionData[i].fat
                                  .toString(),
                              miltType: controller
                                  .milkCollectionData[i].milkType
                                  .toString(),
                              priceV: controller
                                  .milkCollectionData[i].ratePerLiter
                                  .toString(),
                              qtyV: controller.milkCollectionData[i].qty!
                                  .toDouble()
                                  .ceil()
                                  .toString(),
                              snfV: controller.milkCollectionData[i].snf
                                  .toString(),
                              waterV: controller
                                  .milkCollectionData[i].addedWater
                                  .toString(),
                            );
                          }),
                    )
                  : const SizedBox()),
              // collectionTable()
            ],
          ),
        ),
      ),
    );
  }

  Widget intrinsicWidget({
    String? title1,
    String? value1,
    String? title2,
    String? value2,
    String? title3,
    String? value3,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: Get.width * 0.20,
                child: Text(
                  title1.toString(),
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                  style: Theme.of(Get.context!).textTheme.bodySmall,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                width: Get.width * 0.20,
                child: Text(
                  value1.toString(),
                  // textAlign: TextAlign.justify,
                  textAlign: TextAlign.center,

                  overflow: TextOverflow.visible,
                  style: Theme.of(Get.context!).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 10.w,
          ),
          const VerticalDivider(
            color: AppColors.white,
            thickness: 2,
          ),
          SizedBox(
            width: 10.w,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: Get.width * 0.20,
                child: Text(
                  title2.toString(),
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                  style: Theme.of(Get.context!).textTheme.bodySmall,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                width: Get.width * 0.20,
                child: Text(
                  value2.toString(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: Theme.of(Get.context!).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 10.w,
          ),
          const VerticalDivider(
            color: AppColors.white,
            thickness: 2,
          ),
          SizedBox(
            width: 10.w,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width * 0.20,
                child: Text(
                  title3.toString(),
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                  style: Theme.of(Get.context!).textTheme.bodySmall,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                width: Get.width * 0.20,
                // alignment: Alignment.center,
                child: Text(
                  value3.toString(),
                  overflow: TextOverflow.visible,
                  style: Theme.of(Get.context!).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget cardWidget() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  Get.toNamed(
                    Routes.COLLECTMILK,
                  );
                },
                child: SizedBox(
                  width: Get.width * 0.19,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 20.sp,
                        backgroundColor: Colors.white,
                        child: Image.asset("assets/images/ic_collectmilk.png"),
                      ),
                      SizedBox(
                        // width: Get.width * 0.20,
                        child: Text(
                          "Collect Milk",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: Theme.of(Get.context!)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 17.w,
              ),
              const VerticalDivider(
                color: AppColors.white,
                thickness: 2,
              ),
              SizedBox(
                width: 10.w,
              ),
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.FARMERLIST);
                },
                child: SizedBox(
                  width: Get.width * 0.15,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 20.sp,
                        backgroundColor: Colors.white,
                        child: Image.asset("assets/images/ic_farmer.png"),
                      ),
                      SizedBox(
                        // width: Get.width * 0.20,
                        child: Text(
                          "Farmer",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: Theme.of(Get.context!)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const VerticalDivider(
                color: AppColors.white,
                thickness: 2,
              ),
              SizedBox(
                width: 17.w,
              ),
              InkWell(
                onTap: () {
                  // Get.toNamed(Routes.);
                },
                child: SizedBox(
                  width: Get.width * 0.19,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20.sp,
                        backgroundColor: Colors.white,
                        child: Image.asset("assets/images/ic_report.png"),
                      ),
                      SizedBox(
                        // width: Get.width * 0.20,
                        child: Text(
                          "Rate Chart",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: Theme.of(Get.context!)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          color: AppColors.white,
          thickness: 2,
        ),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  bool result = await InternetConnection().hasInternetAccess;

                  await controller.getShiftDetails().then((value) {
                    if (controller.cansModel.isNotEmpty) {
                      controller.printDetails = true;

                      if (result) {
                        controller
                            .printShiftDetails()
                            .then((value) => Get.back());
                      } else {
                        Get.back();
                      }
                    } else {
                      controller.showDialogManualPin(onTap: () async {
                        if (controller.cowCans.isNotEmpty &&
                            controller.bufCans.isNotEmpty) {
                          await controller.cansDB.create(
                            FUploaded: 1,
                            bufCans: controller.bufCans,
                            cowCans: controller.cowCans,
                            date: DateFormat("dd-MMM-yyyy")
                                .format(DateTime.now()),
                            shift: controller.radio == 1 ? "Am" : "Pm",
                          );
                          controller.printDetails = true;

                          if (result) {
                            controller
                                .printShiftDetails()
                                .then((value) => Get.back());
                          } else {
                            Get.back();
                          }
                        }
                      });
                    }
                  });
                },
                child: SizedBox(
                  width: Get.width * 0.19,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20.sp,
                        child: Image.asset(
                          "assets/images/ic_download.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        // width: Get.width * 0.20,
                        child: Text(
                          "Shift Details",
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                          style: Theme.of(Get.context!)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 17.w,
              ),
              const VerticalDivider(
                color: AppColors.white,
                thickness: 2,
              ),
              SizedBox(
                width: 10.w,
              ),
              InkWell(
                onTap: () async {
                  Get.toNamed(Routes.PAYMENT_SUMMARY);
                  // controller.ipvCheck = true;
                  // controller.printStatus = true;
                },
                child: SizedBox(
                  width: Get.width * 0.16,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20.sp,
                        backgroundColor: Colors.white,
                        child: Image.asset("assets/images/ic_payment.png"),
                      ),
                      SizedBox(
                        // width: Get.width * 0.20,
                        child: Text(
                          "Payment",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: Theme.of(Get.context!)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const VerticalDivider(
                color: AppColors.white,
                thickness: 2,
              ),
              SizedBox(
                width: 17.w,
              ),
              InkWell(
                onTap: () async {
                  bool result = await InternetConnection().hasInternetAccess;

                  await controller.getShiftDetails().then((value) async {
                    if (controller.cansModel.isEmpty) {
                      controller.showDialogManualPin(onTap: () async {
                        await controller.cansDB.create(
                          FUploaded: 1,
                          bufCans: controller.bufCans,
                          cowCans: controller.cowCans,
                          date:
                              DateFormat("dd-MMM-yyyy").format(DateTime.now()),
                          shift: controller.radio == 1 ? "Am" : "Pm",
                        );
                        controller.printSummary = true;

                        if (result) {
                          Get.back();
                          await controller
                              .checkSmsFlag()
                              .then((value) => Get.back());
                        } else {
                          Get.back();
                        }
                      });
                    } else {
                      // await controller.getShiftDetails().then((value) async {
                      // controller.;
                      controller.printSummary = true;
                      if (result) {
                        await controller.checkSmsFlag();
                      }
                      // });
                    }
                  });
                },
                child: SizedBox(
                  width: Get.width * 0.19,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20.sp,
                        backgroundColor: Colors.white,
                        child: Image.asset("assets/images/ic_printer.png"),
                      ),
                      SizedBox(
                        // width: Get.width * 0.20,
                        child: Text(
                          "Print Summary",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: Theme.of(Get.context!)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget collectionTable({
    required String fNmae,
    required String fId,
    required String miltType,
    required String fatV,
    required String snfV,
    required String waterV,
    required String qtyV,
    required String priceV,
    required String amtV,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColors.button.withOpacity(0.3),
                border: const Border(
                  top: BorderSide(
                    color: AppColors.white,
                    width: 2,
                  ),
                  left: BorderSide(
                    color: AppColors.white,
                    width: 2,
                  ),
                  right: BorderSide(
                    color: AppColors.white,
                    width: 2,
                  ),
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                )),
            padding: const EdgeInsets.all(5),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    fNmae,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    style: Theme.of(Get.context!).textTheme.titleSmall,
                  ),
                  const VerticalDivider(
                    color: AppColors.white,
                    thickness: 2,
                  ),
                  Text(
                    fId,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    style: Theme.of(Get.context!).textTheme.titleSmall,
                  ),
                  const VerticalDivider(
                    color: AppColors.white,
                    thickness: 2,
                  ),
                  Text(
                    miltType,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    style: Theme.of(Get.context!).textTheme.titleSmall,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                // color: AppColors.brown,
                border: Border.all(
              color: AppColors.white,
              width: 2,
            )),
            padding: const EdgeInsets.all(5),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "Fat",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: Theme.of(Get.context!)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.black),
                      ),
                      Text(
                        fatV,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: Theme.of(Get.context!).textTheme.titleSmall,
                      ),
                    ],
                  ),

                  const VerticalDivider(
                    color: AppColors.white,
                    thickness: 2,
                  ),
                  // SizedBox(
                  //   width: 10.w,
                  // ),
                  Column(
                    children: [
                      Text(
                        "Snf",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: Theme.of(Get.context!)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.black),
                      ),
                      Text(
                        snfV,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: Theme.of(Get.context!).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const VerticalDivider(
                    color: AppColors.white,
                    thickness: 2,
                  ),

                  Column(
                    children: [
                      Text(
                        "Water(%)",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: Theme.of(Get.context!)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.black),
                      ),
                      Text(
                        waterV,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: Theme.of(Get.context!).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const VerticalDivider(
                    color: AppColors.white,
                    thickness: 2,
                  ),
                  Column(
                    children: [
                      Text(
                        "Qty",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: Theme.of(Get.context!)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.black),
                      ),
                      Text(
                        qtyV,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: Theme.of(Get.context!).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const VerticalDivider(
                    color: AppColors.white,
                    thickness: 2,
                  ),

                  Column(
                    children: [
                      Text(
                        "Price",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: Theme.of(Get.context!)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.black),
                      ),
                      Text(
                        priceV,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: Theme.of(Get.context!).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const VerticalDivider(
                    color: AppColors.white,
                    thickness: 2,
                  ),

                  Column(
                    children: [
                      Text(
                        "Amt",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: Theme.of(Get.context!)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: AppColors.black),
                      ),
                      Text(
                        amtV,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: Theme.of(Get.context!).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
