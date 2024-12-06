import 'package:get/get.dart';

import '../controllers/pinverify_controller.dart';

class PinverifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PinverifyController>(
      () => PinverifyController(),
    );
  }
}
