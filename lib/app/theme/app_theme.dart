import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app_colors.dart';
import 'app_dimens.dart';

class AppTheme {
  //  AppTheme._();

  static ThemeData get theme {
    final themeData = ThemeData.light();
    final textTheme = themeData.textTheme;

    return ThemeData(
        scaffoldBackgroundColor: Color(0xffAF8260),
        fontFamily: "Nunito",
        useMaterial3: true,
        textTheme: textTheme.copyWith(
            bodyLarge: const TextStyle(
              color: AppColors.white,
              fontSize: AppDimens.font50,
              fontWeight: FontWeight.bold,
              letterSpacing: 5,
            ),
            bodyMedium: const TextStyle(
              color: AppColors.white,
              fontSize: AppDimens.font20,
              fontWeight: FontWeight.bold,
            ),
            bodySmall: const TextStyle(
              color: AppColors.white,
              fontSize: AppDimens.font14,
              fontWeight: FontWeight.bold,
            ),
            displayLarge: const TextStyle(
              color: AppColors.black,
              fontSize: AppDimens.font20,
              fontWeight: FontWeight.bold,
            ),
            displayMedium: const TextStyle(
              color: AppColors.black,
              fontSize: AppDimens.font18,
              fontWeight: FontWeight.bold,
            ),
            displaySmall: const TextStyle(
              color: AppColors.black,
              fontSize: AppDimens.font12,
              fontWeight: FontWeight.bold,
            ),
            labelSmall: const TextStyle(
              color: AppColors.white,
              fontSize: AppDimens.font16,
              fontWeight: FontWeight.bold,
            ),
            labelMedium: const TextStyle(
              color: AppColors.black,
              fontSize: AppDimens.font14,
              fontWeight: FontWeight.bold,
            ),
            titleSmall: const TextStyle(
              color: AppColors.white,
              fontSize: AppDimens.font12,
              fontWeight: FontWeight.bold,
            )),
        colorScheme: const ColorScheme.light(
          background: AppColors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.appBar,
          titleTextStyle: TextStyle(
            color: AppColors.white,
            fontFamily: "Kalnia_Expanded-Bold",
            fontWeight: FontWeight.bold,
            fontSize: AppDimens.font18,
          ),
          iconTheme: IconThemeData(color: AppColors.white),
          actionsIconTheme: IconThemeData(
            color: AppColors.purple_200,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            side: const BorderSide(color: AppColors.yellow),
            minimumSize: Size(150.w, 35.h),
            maximumSize: const Size.fromWidth(double.infinity),
            shadowColor: AppColors.button,
            backgroundColor: AppColors.darkBrown,
            textStyle: const TextStyle(
              color: AppColors.white,
              fontSize: AppDimens.font18,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          errorStyle: const TextStyle(color: AppColors.red),
          // fillColor: AppColors.purple_200,

          iconColor: AppColors.blueDark,
          suffixIconColor: AppColors.brown,
          prefixIconColor: AppColors.brown,
          outlineBorder: const BorderSide(
            color: AppColors.black,
          ),
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: AppColors.black,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: AppColors.black,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: AppColors.red,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: AppColors.black,
            ),
          ),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            fillColor: AppColors.black,
          ),
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: AppColors.blueDark.withOpacity(0.7),
        ),
        datePickerTheme: const DatePickerThemeData(
          dayStyle: TextStyle(
            color: AppColors.black,
            fontSize: AppDimens.font10,
            fontWeight: FontWeight.bold,
            letterSpacing: 5,
          ),
          weekdayStyle: TextStyle(
            color: AppColors.black,
            fontSize: AppDimens.font10,
            fontWeight: FontWeight.bold,
            letterSpacing: 5,
          ),
          yearStyle: TextStyle(
            color: AppColors.black,
            fontSize: AppDimens.font10,
            fontWeight: FontWeight.bold,
            letterSpacing: 5,
          ),
        ));
  }
}
