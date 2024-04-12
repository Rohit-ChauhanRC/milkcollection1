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
import '../modules/pinverify/bindings/pinverify_binding.dart';
import '../modules/pinverify/views/pinverify_view.dart';
import '../modules/shiftdetails/bindings/shiftdetails_binding.dart';
import '../modules/shiftdetails/views/shiftdetails_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

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
  ];
}
