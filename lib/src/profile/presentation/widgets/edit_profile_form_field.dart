import 'package:flutter/material.dart';
import 'package:mustye/core/common/widgets/my_field.dart';

class EditProfileFormField extends StatelessWidget {
  const EditProfileFormField({
    required this.title,
    required this.controller,
    this.hintText,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLength,
    this.counterText,
    this.isTextArea = false,
    super.key,
  });

  final String title;
  final String? hintText;
  final TextEditingController controller;
  final bool readOnly;
  final String? counterText;
  final int? maxLength;
  final bool isTextArea;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5,),
        MyField(
          hintText: hintText,
          controller: controller,
          readOnly: readOnly,
          // counterText: counterText != null ? '$counterText/$maxLength' : null,
          maxLength: maxLength,
          isTextArea: isTextArea,
        ),
      ],
    );
  }
}
