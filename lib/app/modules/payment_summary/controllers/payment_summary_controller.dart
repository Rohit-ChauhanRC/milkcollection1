import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:milkcollection/app/constants/contants.dart';
import 'package:milkcollection/app/data/models/get_farmer_payment_model.dart';
import 'package:milkcollection/app/modules/home/controllers/home_controller.dart';

class PaymentSummaryController extends GetxController {
  //

  final HomeController homeController = Get.find<HomeController>();

  final box = GetStorage();

  final RxString _username = ''.obs;
  String get username => _username.value;
  set username(String mob) => _username.value = mob;

  final RxString _search = ''.obs;
  String get search => _search.value;
  set search(String mob) => _search.value = mob;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getFamerPaymentSummaryApi() async {
    try {
      var res = await http.get(
        Uri.parse(
          "$baseUrlConst/$getFatmerPaymentSummaryConst?CollectionCenterId=${box.read("centerId")}&FromDate=${homeController.fromDateP}&ToDate=${homeController.toDateP}",
        ),
      );

      if (res.statusCode == 200) {
        homeController.farmerPaymentList.assignAll([]);

        homeController.farmerPaymentList
            .assignAll(getFarmerPaymentModelFromMap(res.body));
      } else {}
    } catch (e) {}
  }

  Future<void> getSearchFarmerData() async {
    for (var i = 0; i < homeController.farmerPaymentList.length; i++) {
      if (homeController.farmerPaymentList[i].farmerName
          .toString()
          .toLowerCase()
          .contains(search.trim().toLowerCase())) {
        homeController.searchfarmerPaymentList
            .assign(homeController.farmerPaymentList[i]);

        update();
      }
    }

    // print(searchfarmerData);
  }

  void printSummary() {
    homeController.printPaymentSummary = true;
  }
}
