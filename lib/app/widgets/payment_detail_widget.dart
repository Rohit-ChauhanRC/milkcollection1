import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milkcollection/app/theme/app_colors.dart';

class PaymentDetailWidget extends StatelessWidget {
  const PaymentDetailWidget({
    super.key,
    required this.farmerName,
    required this.farmerId,
    required this.milktype,
    required this.shift,
    required this.date,
    required this.fat,
    required this.snf,
    required this.water,
    required this.qty,
    required this.price,
    required this.amt,
  });

  final String farmerName;
  final String farmerId;
  final String milktype;
  final String shift;
  final String date;
  final String fat;
  final String snf;
  final String water;
  final String qty;
  final String price;
  final String amt;

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
                  milktype.isNotEmpty ? milktype : "",
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
                  shift.isNotEmpty ? shift : "",
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
                  date.isNotEmpty ? date : "",
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
                      "Fat",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: Theme.of(Get.context!)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: AppColors.black),
                    ),
                    Text(
                      fat,
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
                      snf,
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
                      water,
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
                      qty,
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
                      price,
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
                      amt,
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
      ]),
    );
  }
}
