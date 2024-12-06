import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milkcollection/app/theme/app_colors.dart';

class PaymentFarmerWidget extends StatelessWidget {
  const PaymentFarmerWidget({
    super.key,
    required this.farmerName,
    required this.farmerId,
    required this.totalQty,
    required this.totalAmt,
    required this.adjBalance,
    required this.netAmt,
    required this.paymentId,
    required this.fromDate,
    required this.toDate,
    required this.releasedOn,
  });
  final String farmerName;
  final String farmerId;
  final String totalQty;
  final String totalAmt;
  final String adjBalance;
  final String netAmt;
  final String paymentId;
  final String fromDate;
  final String toDate;
  final String releasedOn;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(children: [
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
                  farmerName.isNotEmpty ? farmerName : "",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: Theme.of(Get.context!)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: AppColors.white),
                ),
                const VerticalDivider(
                  color: AppColors.white,
                  thickness: 2,
                ),
                Text(
                  farmerId.isNotEmpty ? farmerId : '',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: Theme.of(Get.context!)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: AppColors.white),
                ),
                const VerticalDivider(
                  color: AppColors.white,
                  thickness: 2,
                ),
                Text(
                  "Total Qyt: ${totalQty.isNotEmpty ? totalQty : ""}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: Theme.of(Get.context!)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: AppColors.white),
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
                      "Tot. Amt.",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: Theme.of(Get.context!)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: AppColors.black),
                    ),
                    Text(
                      totalAmt.isNotEmpty ? totalAmt : "",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: Theme.of(Get.context!)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: AppColors.white),
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
                      "Adj. Balance",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: Theme.of(Get.context!)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: AppColors.black),
                    ),
                    Text(
                      adjBalance.isNotEmpty ? adjBalance : "",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: Theme.of(Get.context!)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: AppColors.white),
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
                      "Net Amt.",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: Theme.of(Get.context!)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: AppColors.black),
                    ),
                    Text(
                      netAmt.isNotEmpty ? netAmt : "",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: Theme.of(Get.context!)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: AppColors.white),
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
                      "Payment Id",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: Theme.of(Get.context!)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: AppColors.black),
                    ),
                    Text(
                      paymentId.isNotEmpty ? paymentId : "",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: Theme.of(Get.context!)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: AppColors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: AppColors.button.withOpacity(0.3),
              border: const Border(
                bottom: BorderSide(
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
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
                topLeft: Radius.zero,
                topRight: Radius.zero,
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
                  "From: ${fromDate.isNotEmpty ? fromDate.substring(5, toDate.length) : ""}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: Theme.of(Get.context!)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: AppColors.white),
                ),
                const VerticalDivider(
                  color: AppColors.white,
                  thickness: 2,
                ),
                Text(
                  "To: ${toDate.isNotEmpty ? toDate.substring(5, toDate.length) : ""}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: Theme.of(Get.context!)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: AppColors.white),
                ),
                const VerticalDivider(
                  color: AppColors.white,
                  thickness: 2,
                ),
                Text(
                  "Released on: ${releasedOn.isNotEmpty ? releasedOn.substring(5, toDate.length) : ""}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: Theme.of(Get.context!)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: AppColors.white),
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
