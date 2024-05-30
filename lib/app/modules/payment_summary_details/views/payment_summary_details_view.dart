import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:milkcollection/app/widgets/backdround_container.dart';
import 'package:milkcollection/app/widgets/payment_detail_widget.dart';

import '../controllers/payment_summary_details_controller.dart';

class PaymentSummaryDetailsView
    extends GetView<PaymentSummaryDetailsController> {
  const PaymentSummaryDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        centerTitle: true,
      ),
      body: BackgroundContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() =>
                  controller.farmerPaymentList.isNotEmpty && controller.progress
                      ? Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          height: Get.height * 0.85,
                          child: ListView.builder(
                              itemCount: controller.farmerPaymentList.length,
                              itemBuilder: (ctx, i) {
                                final farmer = controller.farmerPaymentList[i];
                                return PaymentDetailWidget(
                                  farmerId: farmer.idNo.toString(),
                                  farmerName: farmer.farmerName.toString(),
                                  amt: farmer.totalAmount.toString(),
                                  date: farmer.collectionDate.toString(),
                                  fat: farmer.fat.toString(),
                                  milktype: farmer.milkType.toString(),
                                  price: farmer.rate.toString(),
                                  qty: farmer.quantity.toString(),
                                  shift: farmer.shift.toString(),
                                  snf: farmer.snf.toString(),
                                  water: farmer.addedWater.toString(),
                                );
                              }),
                        )
                      : const CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
