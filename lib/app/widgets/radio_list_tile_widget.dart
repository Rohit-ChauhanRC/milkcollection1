import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';

class RadioBoxFormField extends FormField<bool> {
  RadioBoxFormField({
    super.key,
    Widget? title,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    required int value,
    required Function(int?)? onChanged,
    required int selectedRadioTile,
    // bool initialValue = false,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            // initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              return RadioListTile(
                activeColor: AppColors.yellow,
                dense: state.hasError,
                title: title,
                value: value,
                onChanged: onChanged,
                subtitle: state.hasError
                    ? Text(
                        state.errorText!,
                        style: Theme.of(Get.context!).textTheme.displayMedium,
                      )
                    : null,
                controlAffinity: ListTileControlAffinity.leading,
                groupValue: selectedRadioTile,
              );
            });
}
