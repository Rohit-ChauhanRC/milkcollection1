import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milkcollection/app/widgets/text_form_widget.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class Utils {
  const Utils._();
  //

  static void closeKeyboard() {
    final currentFocus = Get.focusScope;
    // if (!currentFocus.hasPrimaryFocus) {
    currentFocus!.unfocus();
    // }
  }

  static void loadingDialog() {
    Utils.closeDialog();

    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static void closeDialog() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  static void closeSnackbar() {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
  }

  static void showDialog(String message) => Get.defaultDialog(
        barrierDismissible: false,
        backgroundColor: AppColors.white,
        onWillPop: () async {
          Get.back();

          return true;
        },
        titleStyle: const TextStyle(color: AppColors.red),
        // title: success ? Strings.success : title,
        content: Text(
          message,
          textAlign: TextAlign.center,
          maxLines: 6,
          style: const TextStyle(
            color: AppColors.darkBrown,
            fontSize: AppDimens.font16,
          ),
        ),
        confirm: Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Text(
              "OK",
              style: TextStyle(
                color: AppColors.blueDark,
                fontSize: AppDimens.font16,
              ),
            ),
          ),
        ),
      );
  static void showDialogManualPin({
    Function()? onTap,
    required String initialValue,
  }) =>
      Get.defaultDialog(
        barrierDismissible: false,
        backgroundColor: AppColors.white,
        title: "Validate Pin",
        titleStyle: Theme.of(Get.context!).textTheme.displayMedium,
        // title: success ? Strings.success : title,
        content: TextFormWidget(
          prefix: const Icon(
            Icons.pin,
            size: 30,
          ),
          initialValue: initialValue,
          label: "Please enter Pin...",
          onChanged: (val) {
            initialValue = val;
            print(initialValue);
          },
          keyboardType: const TextInputType.numberWithOptions(
            signed: true,
          ),
          maxLength: 10,
        ),
        // cancel: ,
        confirm: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: AppColors.darkBrown,
                    fontSize: AppDimens.font16,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: onTap,
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: AppColors.darkBrown,
                    fontSize: AppDimens.font16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  static showSnackbar(String message) {
    return ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        backgroundColor: AppColors.white,
        showCloseIcon: true,
        closeIconColor: AppColors.red,
        content: Text(
          message,
          style: Theme.of(Get.context!).textTheme.displayMedium,
        )));
  }

  static Future<DateTime?> showIOSDatePicker(
      ctx, void Function(DateTime?) onDateTimeChanged) {
    return showCupertinoModalPopup(
        context: ctx,
        builder: (BuildContext context) => Container(
              height: 190,
              color: AppColors.blueDark,
              child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                onDateTimeChanged: onDateTimeChanged,
                mode: CupertinoDatePickerMode.date,
                maximumDate: DateTime.now(),
                // dateOrder: DatePickerDateOrder.,
              ),
            ));
  }
}
