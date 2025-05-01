import 'package:flutter/material.dart';
import 'package:mustye/core/res/colors.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    required this.message,
    required this.time,
    this.messageColor,
    this.timeColor,
    this.boxColor,
    this.isCurrentUser = true,
    super.key,
  });

  final String message;
  final String time;
  final Color? messageColor;
  final Color? timeColor;
  final Color? boxColor;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color:
              boxColor ??
              (isCurrentUser ? Colours.primaryColor : Colors.grey.shade300),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isCurrentUser ? 12 : 0),
            bottomRight: Radius.circular(isCurrentUser ? 0 : 12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:
                      messageColor ??
                      (isCurrentUser ? Colors.white : Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color:
                        timeColor ??
                        (isCurrentUser
                            ? Colors.grey.shade200
                            : Colors.grey.shade800),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
