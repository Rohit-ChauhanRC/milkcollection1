import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:milkcollection/app/constants/contants.dart';
import 'package:milkcollection/app/data/models/get_farmer_payment_details_model.dart';
import 'package:http/http.dart' as http;
import 'package:milkcollection/app/modules/home/controllers/home_controller.dart';

class PaymentSummaryDetailsController extends GetxController {
  //farmer.idNo,
  // controller.fromDate,
  // controller.toDate

  final HomeController homeController = Get.find();

  final box = GetStorage();

  final RxList<GetFarmerPaymentDetailsModel> _farmerPaymentList =
      RxList<GetFarmerPaymentDetailsModel>();
  List<GetFarmerPaymentDetailsModel> get farmerPaymentList =>
      _farmerPaymentList;
  set farmerPaymentList(List<GetFarmerPaymentDetailsModel> lst) =>
      _farmerPaymentList.assignAll(lst);

  final RxBool _progress = true.obs;
  bool get progress => _progress.value;
  set progress(bool v) => _progress.value = v;

  // final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    await getFamerPaymentDetails();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getFamerPaymentDetails() async {
    progress = false;
    try {
      var res = await http.get(
        Uri.parse(
          "$baseUrlConst/$getFarmerPaymentDetialsConst?CollectionCenterId=${box.read("centerId")}&FromDate=${Get.arguments[1]}&ToDate=${Get.arguments[2]}",
        ),
      );

      if (res.statusCode == 200) {
        farmerPaymentList.assignAll([]);

        farmerPaymentList
            .assignAll(getFarmerPaymentDetailsModelFromMap(res.body));

        if (farmerPaymentList.isNotEmpty) {
          farmerPaymentList
              .removeWhere((element) => element.idNo != Get.arguments[0]);
        }
      } else {}
    } catch (e) {}
    progress = true;
  }

  void printSummary() {
    if (farmerPaymentList.isNotEmpty) {
      homeController.printFarmerPaymentDetails(
        data: farmerPaymentList,
        farmerId: farmerPaymentList[0].idNo.toString(),
        farmerName: farmerPaymentList[0].farmerName.toString(),
      );
    }
  }
}
