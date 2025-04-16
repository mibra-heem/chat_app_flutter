import 'package:flutter/material.dart';
import 'package:mustye/core/res/colors.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    required this.message,
    this.textColor,
    this.boxColor,
    this.isCurrentUser = true,
    super.key,
  });

  final String message;
  final Color? textColor;
  final Color? boxColor;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width * 0.75, // max 75% of screen
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color:
              boxColor ?? (isCurrentUser ? Colours.primaryColor.shade900 : Colors.grey.shade300),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isCurrentUser ? 12 : 0),
            bottomRight: Radius.circular(isCurrentUser ? 0 : 12),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor ?? (isCurrentUser ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
