import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:milkcollection/app/routes/app_pages.dart';
import 'package:milkcollection/app/theme/app_colors.dart';
import 'package:milkcollection/app/widgets/backdround_container.dart';
import 'package:milkcollection/app/widgets/payment_farmer_widget.dart';
import 'package:milkcollection/app/widgets/text_form_widget.dart';

import '../controllers/payment_summary_controller.dart';

class PaymentSummaryView extends GetView<PaymentSummaryController> {
  const PaymentSummaryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        centerTitle: true,
      ),
      body: BackgroundContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 5, left: 20, right: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          controller.homeController.fromDateP =
                              DateFormat("dd-MMM-yyyy").format(DateTime.parse(
                                  selectedDate!.toIso8601String()));
                          print(controller.homeController.fromDateP);
                        });
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.white,
                          ),
                          Obx(() => Text(
                                controller.homeController.fromDateP.isNotEmpty
                                    ? controller.homeController.fromDateP
                                    : "from date",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: AppColors.white),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                        ).then((selectedDate) async {
                          controller.homeController.toDateP =
                              DateFormat("dd-MMM-yyyy").format(DateTime.parse(
                                  selectedDate!.toIso8601String()));
                          print(controller.homeController.toDateP);
                        });
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.white,
                          ),
                          Obx(() => Text(
                                controller.homeController.toDateP.isNotEmpty
                                    ? controller.homeController.toDateP
                                    : "to date",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: AppColors.white),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () async {
                            controller.getFamerPaymentSummaryApi();
                          },
                          child: Text(
                            "Search",
                            style: Theme.of(context).textTheme.bodySmall!,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      controller.printSummary();
                    },
                    child: Text(
                      "Print",
                      style: Theme.of(context).textTheme.bodySmall!,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter Farmer Name:",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Obx(() => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormWidget(
                      prefix: const Icon(
                        Icons.person,
                        size: 30,
                      ),
                      // obscureText: true,
                      initialValue: controller.search.isNotEmpty
                          ? controller.search
                          : " Enter Farmer name",
                      label: "Please enter Password...",
                      onChanged: (val) {
                        controller.search = val;
                        if (controller.search.trim().isNotEmpty) {
                          controller.homeController.searchActive = true;
                          controller.getSearchFarmerData();
                        } else {
                          controller.homeController.searchActive = false;
                          controller.getFamerPaymentSummaryApi();
                        }
                      },
                      keyboardType: TextInputType.text,
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              Obx(() => controller.homeController.farmerPaymentList.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: Get.height * 0.63,
                      child: ListView.builder(
                          itemCount: controller.homeController.searchActive
                              ? controller
                                  .homeController.searchfarmerPaymentList.length
                              : controller
                                  .homeController.farmerPaymentList.length,
                          itemBuilder: (ctx, i) {
                            final farmer =
                                controller.homeController.searchActive
                                    ? controller.homeController
                                        .searchfarmerPaymentList[i]
                                    : controller
                                        .homeController.farmerPaymentList[i];
                            return InkWell(
                              onTap: () {
                                Get.toNamed(Routes.PAYMENT_SUMMARY_DETAILS,
                                    arguments: [
                                      farmer.idNo,
                                      controller.homeController.fromDateP,
                                      controller.homeController.toDateP
                                    ]);
                              },
                              child: PaymentFarmerWidget(
                                adjBalance: farmer.oldAdj.toString(),
                                farmerId: farmer.idNo.toString(),
                                farmerName: farmer.farmerName.toString(),
                                fromDate: farmer.fromDate.toString(),
                                toDate: farmer.toDate.toString(),
                                netAmt: farmer.netAmount.toString(),
                                paymentId: farmer.paymentId.toString(),
                                releasedOn: farmer.releaseDate.toString(),
                                totalAmt: farmer.totalAmount.toString(),
                                totalQty: farmer.totalQty.toString(),
                              ),
                            );
                          }),
                    )
                  : const SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
