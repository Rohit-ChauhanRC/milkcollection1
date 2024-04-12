import 'package:get/get.dart';

class HomeController extends GetxController {
  //
  final RxInt _radio = 1.obs;
  int get radio => _radio.value;
  set radio(int i) => _radio.value = i;

  @override
  void onInit() {
    super.onInit();
    if (DateTime.now().hour < 12) {
      radio = 1;
    } else {
      radio = 2;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
