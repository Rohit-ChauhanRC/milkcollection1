import 'package:get/get.dart';

import '../controllers/shiftdetails_controller.dart';

class ShiftdetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShiftdetailsController>(
      () => ShiftdetailsController(),
    );
  }
}
