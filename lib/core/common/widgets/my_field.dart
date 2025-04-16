import 'package:flutter/material.dart';
import 'package:mustye/core/extensions/context_extension.dart';

class MyField extends StatelessWidget {
  const MyField({
    required this.controller,
    this.matchField = '',
    this.validator,
    this.filled = false,
    this.fillColor,
    this.obscureText = false,
    this.validatePassword = false,
    this.keyboardType,
    this.readOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    this.hintText,
    this.hintStyle,
    this.overrideValidator = false,
    this.isTextArea = false,
    this.maxLines,
    this.counterText,
    this.maxLength,
    this.isFocusOnTapOutside = true,
    super.key,
  });

  final TextEditingController controller;
  final String matchField;
  final String? Function(String?)? validator;
  final bool filled;
  final Color? fillColor;
  final bool obscureText;
  final bool validatePassword;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextStyle? hintStyle;
  final bool overrideValidator;
  final int? maxLines;
  final bool isTextArea;
  final String? counterText;
  final int? maxLength;
  final bool isFocusOnTapOutside;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: overrideValidator ? validator : (value){
        if(value == null || value == ''){
          return 'This field is required.';
        }
        return validator?.call(value);
      },
      onTapOutside: isFocusOnTapOutside 
        ? (_) => FocusScope.of(context).unfocus() 
        : null,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: isTextArea ? 4 : 1,
      maxLength: isTextArea ? maxLength : null,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: filled,
        fillColor: fillColor,
        counterText: isTextArea ? counterText : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: context.theme.primaryColor,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 12,
        ),
      ),
    );
  }
}
