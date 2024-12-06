import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:milkcollection/app/theme/app_dimens.dart';

class DateTimePickerWidget extends StatelessWidget {
  final Color? iconColor;
  final void Function(DateTime?)? onSaved;
  final void Function(DateTime?)? onChanged;
  final String? hintText;
  final TextStyle? style;
  final String? Function(DateTime?)? validate;
  final DateTime? initialDate;
  DateTime? lastDate;
  DateTimePickerWidget({
    Key? key,
    this.iconColor,
    this.onChanged,
    this.hintText,
    this.style,
    this.validate,
    this.onSaved,
    this.initialDate,
    this.lastDate,
  }) : super(key: key);

  final format = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      initialValue: initialDate,
      style: style ?? const TextStyle(fontSize: AppDimens.font12),
      textAlign: TextAlign.start,
      onSaved: onSaved,
      validator: validate,
      format: format,
      onChanged: onChanged,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? initialDate,
            lastDate: lastDate ?? DateTime(2100));
      },
    );
  }
}
