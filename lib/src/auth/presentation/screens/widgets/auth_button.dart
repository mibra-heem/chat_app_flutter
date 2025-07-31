import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    required this.image,
    required this.color,
    this.size,
    this.onTap,
    super.key,
  });

  final ImageProvider image;
  final Color color;
  final double? size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, 
      child: Image(
        height: 40,
        width: 40,
        image: image,
      ),
    );
  }
}
