import 'package:get/get.dart';

import '../controllers/payment_summary_details_controller.dart';

class PaymentSummaryDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentSummaryDetailsController>(
      () => PaymentSummaryDetailsController(),
    );
  }
}
