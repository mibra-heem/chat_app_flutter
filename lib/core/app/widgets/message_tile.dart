import 'package:flutter/material.dart';
import 'package:mustye/core/app/resources/colors.dart';
import 'package:mustye/core/extensions/context_extension.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    required this.message,
    required this.time,
    this.messageColor,
    this.timeColor,
    this.boxColor,
    this.isCurrentUser = true,
    this.isSeen = false,
    this.onTap,
    this.onLongPressStart,
    super.key,
  });

  final String message;
  final String time;
  final Color? messageColor;
  final Color? timeColor;
  final Color? boxColor;
  final bool isCurrentUser;
  final bool isSeen;
  final VoidCallback? onTap;
  final void Function(LongPressStartDetails)? onLongPressStart;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 14,
      color: context.color.onPrimaryContainer,
    );
    final tsStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: timeColor ?? context.color.onTertiaryContainer,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use TextPainter to check line count
        final tp = TextPainter(
          text: TextSpan(text: message, style: textStyle),
          textDirection: TextDirection.ltr,
        )..layout(
          maxWidth: (context.width * 0.75) - 100,
        ); // padding for timestamp

        final isSingleLine = tp.computeLineMetrics().length == 1;
        return Align(
          alignment:
              isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child: GestureDetector(
            onTap: onTap,
            onLongPressStart: onLongPressStart,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              constraints: BoxConstraints(maxWidth: context.width * 0.75),
              decoration: BoxDecoration(
                color:
                    (isCurrentUser
                        ? context.color.primaryContainer
                        : context.color.tertiary),
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  isSingleLine
                      ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(message, style: textStyle),
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(time, style: tsStyle),
                              if (isCurrentUser) ...[
                                const SizedBox(width: 2),
                                Icon(
                                  Icons.done_all,
                                  size: 14,
                                  color:
                                      isSeen ? Colours.success : tsStyle.color,
                                ),
                              ],
                            ],
                          ),
                        ],
                      )
                      : Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: Text(message, style: textStyle),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Row(
                              children: [
                                Text(time, style: tsStyle),
                                if (isCurrentUser) ...[
                                  const SizedBox(width: 2),
                                  Icon(
                                    Icons.done_all,
                                    size: 14,
                                    color:
                                        isSeen
                                            ? Colours.success
                                            : tsStyle.color,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        );
      },
    );
  }
}
