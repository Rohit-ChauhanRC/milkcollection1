import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
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
      body: SingleChildScrollView(
        child: BackgroundContainer(
          child: Column(
            children: [
              // SizedBox(
              //   height: 20.h,
              // ),
              Container(
                margin: const EdgeInsets.only(
                    top: 5, left: 20, right: 20, bottom: 5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.white,
                    ),
                    Text(
                        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}"),
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
                                },
                              ),
                            )),
                        InkWell(
                          child: const Text("AM"),
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
                                },
                              ),
                            )),
                        InkWell(
                          child: const Text("PM"),
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
                    border: Border.all(
                  color: AppColors.white,
                  width: 2,
                )),
                child: Column(
                  children: [
                    Container(
                      // margin: const EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          intrinsicWidget(
                              title1: "Tot Milk",
                              value1: "0.0",
                              title2: "Avg Fat",
                              value2: "0.0",
                              title3: "Avg SNF",
                              value3: "0.0"),
                        ],
                      ),
                    ),
                    const Divider(
                      color: AppColors.white,
                      thickness: 2,
                    ),
                    Container(
                      // margin: const EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          intrinsicWidget(
                              title1: "Avg Milk",
                              value1: "0.0",
                              title2: "Avg Price",
                              value2: "0.0",
                              title3: "Avg Amt",
                              value3: "0.0"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                // margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  // borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.card,
                  ),
                ),
                child: cardWidget(),
              ),
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
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width * 0.20,
                child: Text(
                  title1.toString(),
                  overflow: TextOverflow.visible,
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
                  title2.toString(),
                  overflow: TextOverflow.visible,
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
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              InkWell(
                onTap: () async {
                  // await controller.getRaateChart("C").then((value) async {
                  //   await controller.getRaateChart("B").then((value) async {
                  //     controller.pd.close();
                  Get.toNamed(
                    Routes.COLLECTMILK,
                  );
                  // });
                  // });
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
                        child: Image.asset("assets/images/ic_collectmilk.png"),
                      ),
                      SizedBox(
                        // width: Get.width * 0.20,
                        child: Text(
                          "Collect Milk",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: Theme.of(Get.context!).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
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
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.FARMERLIST);
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
                        child: Image.asset("assets/images/ic_farmer.png"),
                      ),
                      SizedBox(
                        // width: Get.width * 0.20,
                        child: Text(
                          "Farmer",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: Theme.of(Get.context!).textTheme.bodySmall,
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
                width: 10.w,
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
                          style: Theme.of(Get.context!).textTheme.bodySmall,
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
            children: [
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.SHIFTDETAILS);
                },
                child: SizedBox(
                  width: Get.width * 0.19,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        // foregroundColor: Colors.transparent,
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
                          style: Theme.of(Get.context!).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
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
              InkWell(
                onTap: () {
                  // Get.toNamed(Routes.P);
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
                        child: Image.asset("assets/images/ic_payment.png"),
                      ),
                      SizedBox(
                        // width: Get.width * 0.20,
                        child: Text(
                          "Payment",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: Theme.of(Get.context!).textTheme.bodySmall,
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
                width: 10.w,
              ),
              InkWell(
                onTap: () {
                  // Get.toNamed(Routes.COLLECTMILK);
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
                          "Print\nSummary",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: Theme.of(Get.context!).textTheme.bodySmall,
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
}
