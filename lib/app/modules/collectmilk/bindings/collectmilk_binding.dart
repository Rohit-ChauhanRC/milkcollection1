import 'package:get/get.dart';

import '../controllers/collectmilk_controller.dart';

class CollectmilkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CollectmilkController>(
      () => CollectmilkController(),
    );
  }
}
