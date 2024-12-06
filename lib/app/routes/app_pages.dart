import 'package:get/get.dart';

import '../modules/collectmilk/bindings/collectmilk_binding.dart';
import '../modules/collectmilk/views/collectmilk_view.dart';
import '../modules/farmer/bindings/farmer_binding.dart';
import '../modules/farmer/views/farmer_view.dart';
import '../modules/farmerlist/bindings/farmerlist_binding.dart';
import '../modules/farmerlist/views/farmerlist_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/payment_summary/bindings/payment_summary_binding.dart';
import '../modules/payment_summary/views/payment_summary_view.dart';
import '../modules/payment_summary_details/bindings/payment_summary_details_binding.dart';
import '../modules/payment_summary_details/views/payment_summary_details_view.dart';
import '../modules/pinverify/bindings/pinverify_binding.dart';
import '../modules/pinverify/views/pinverify_view.dart';
import '../modules/shiftdetails/bindings/shiftdetails_binding.dart';
import '../modules/shiftdetails/views/shiftdetails_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;
  static const INITIAL1 = Routes.PINVERIFY;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PINVERIFY,
      page: () => const PinverifyView(),
      binding: PinverifyBinding(),
    ),
    GetPage(
      name: _Paths.COLLECTMILK,
      page: () => const CollectmilkView(),
      binding: CollectmilkBinding(),
    ),
    GetPage(
      name: _Paths.FARMER,
      page: () => const FarmerView(),
      binding: FarmerBinding(),
    ),
    GetPage(
      name: _Paths.SHIFTDETAILS,
      page: () => const ShiftdetailsView(),
      binding: ShiftdetailsBinding(),
    ),
    GetPage(
      name: _Paths.FARMERLIST,
      page: () => const FarmerlistView(),
      binding: FarmerlistBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_SUMMARY,
      page: () => const PaymentSummaryView(),
      binding: PaymentSummaryBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_SUMMARY_DETAILS,
      page: () => const PaymentSummaryDetailsView(),
      binding: PaymentSummaryDetailsBinding(),
    ),
  ];
}
