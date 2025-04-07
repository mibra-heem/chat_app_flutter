import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    required this.title,
    required this.color,
    this.size,
    this.onTap,
    super.key,
  });

  final String title;
  final Color color;
  final double? size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: size ?? 32,
          ),
        ),
      ),
    );
  }
}
