import 'package:flutter/material.dart';
import 'package:mustye/core/app/resources/colors.dart';
import 'package:mustye/core/extensions/context_extension.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
    this.label, {
    required this.onPressed,
    this.width,
    this.height,
    this.elevation,
    this.labelColor,
    this.buttonColor,
    super.key,
  });

  final String label;
  final double? width;
  final double? height;
  final Color? labelColor;
  final Color? buttonColor;
  final double? elevation;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        backgroundColor: buttonColor ?? Colours.primary,
        foregroundColor: labelColor ?? Colors.white,
        fixedSize: Size(width ?? context.width, height ?? 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(90),
        ),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600),),
    );
  }
}
