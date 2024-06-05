import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final box = GetStorage();

  runApp(
    ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            title: "Milk Collection",
            initialRoute: box.read("verify") != null
                ? AppPages.INITIAL1
                : AppPages.INITIAL,
            getPages: AppPages.routes,
            theme: AppTheme.theme,
            debugShowCheckedModeBanner: false,
          );
        }),
  );
}
