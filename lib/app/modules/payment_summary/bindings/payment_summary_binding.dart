import 'package:get/get.dart';

import '../controllers/payment_summary_controller.dart';

class PaymentSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentSummaryController>(
      () => PaymentSummaryController(),
    );
  }
}
