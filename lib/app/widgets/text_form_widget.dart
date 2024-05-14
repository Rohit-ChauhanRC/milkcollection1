import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milkcollection/app/theme/app_colors.dart';

class TextFormWidget extends StatelessWidget {
  const TextFormWidget({
    super.key,
    this.onChanged,
    this.label,
    this.keyboardType,
    this.readOnly = false,
    required this.initialValue,
    this.validator,
    this.textController,
    this.suffix = false,
    this.maxLength,
    this.inputFormatters,
    this.prefix,
    this.obscureText = false,
  });

  final void Function(String)? onChanged;
  final String? label;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool suffix;
  final String initialValue;
  final String? Function(String?)? validator;
  final TextEditingController? textController;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        // focusNode: FocusNode(),
        // key: UniqueKey(),
        controller: textController,
        validator: validator,
        initialValue: initialValue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: onChanged,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .apply(color: AppColors.black),
        readOnly: readOnly,
        inputFormatters: inputFormatters,
        textAlign: TextAlign.left,
        keyboardType: keyboardType ?? TextInputType.text,
        obscureText: obscureText,
        decoration: InputDecoration(
          suffixIcon: prefix,
          // contentPadding: EdgeInsets.only(bottom: 10, left: 10)
        )
        //     .applyDefaults(Theme.of(context).inputDecorationTheme),
        );
  }
}
