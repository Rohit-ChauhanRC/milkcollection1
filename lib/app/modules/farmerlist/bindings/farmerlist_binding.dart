import 'package:get/get.dart';

import '../controllers/farmerlist_controller.dart';

class FarmerlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmerlistController>(
      () => FarmerlistController(),
    );
  }
}
