import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:milkcollection/app/constants/contants.dart';
import 'package:milkcollection/app/data/models/get_farmer_payment_model.dart';

class PaymentSummaryController extends GetxController {
  //

  final box = GetStorage();

  final RxString _fromDate = "from date".obs;
  String get fromDate => _fromDate.value;
  set fromDate(String str) => _fromDate.value = str;

  final RxString _toDate = "".obs;
  String get toDate => _toDate.value;
  set toDate(String str) => _toDate.value = str;

  final RxInt _radio = 1.obs;
  int get radio => _radio.value;
  set radio(int i) => _radio.value = i;

  final RxString _username = ''.obs;
  String get username => _username.value;
  set username(String mob) => _username.value = mob;

  final RxList<GetFarmerPaymentModel> _farmerPaymentList =
      RxList<GetFarmerPaymentModel>();
  List<GetFarmerPaymentModel> get farmerPaymentList => _farmerPaymentList;
  set farmerPaymentList(List<GetFarmerPaymentModel> lst) =>
      _farmerPaymentList.assignAll(lst);

  final RxList<GetFarmerPaymentModel> _searchfarmerPaymentList =
      RxList<GetFarmerPaymentModel>();
  List<GetFarmerPaymentModel> get searchfarmerPaymentList =>
      _searchfarmerPaymentList;
  set searchfarmerPaymentList(List<GetFarmerPaymentModel> lst) =>
      _searchfarmerPaymentList.assignAll(lst);

  final RxString _search = ''.obs;
  String get search => _search.value;
  set search(String mob) => _search.value = mob;

  final RxBool _searchActive = false.obs;
  bool get searchActive => _searchActive.value;
  set searchActive(bool v) => _searchActive.value = v;

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
          "$baseUrlConst/$getFatmerPaymentSummaryConst?CollectionCenterId=${box.read("centerId")}&FromDate=$fromDate&ToDate=$toDate",
        ),
      );

      if (res.statusCode == 200) {
        farmerPaymentList.assignAll([]);

        farmerPaymentList.assignAll(getFarmerPaymentModelFromMap(res.body));
      } else {}
    } catch (e) {}
  }

  Future<void> getSearchFarmerData() async {
    for (var i = 0; i < farmerPaymentList.length; i++) {
      if (farmerPaymentList[i]
          .farmerName
          .toString()
          .toLowerCase()
          .contains(search.trim().toLowerCase())) {
        searchfarmerPaymentList.assign(farmerPaymentList[i]);

        update();
      }
    }

    // print(searchfarmerData);
  }
}
