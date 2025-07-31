import 'package:flutter/material.dart';
import 'package:mustye/core/app/resources/media_res.dart';
import 'package:mustye/core/extensions/context_extension.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.image,
    this.tileColor,
    this.unSeenMsgCount = 0,
    this.isLabelVisible = false,
    this.onTap,
    this.onLongPress,
    super.key,
  });

  final String title;
  final String subtitle;
  final String? time;
  final String? image;
  final Color? tileColor;
  final bool isLabelVisible;
  final int unSeenMsgCount;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: tileColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundImage:
                  image != null
                      ? NetworkImage(image!)
                      : const AssetImage(MediaRes.youngManWorkingOnDesk)
                          as ImageProvider,
            ),
            const SizedBox(width: 12),

            // Title, subtitle, and time
            Expanded(
              child: Badge(
                isLabelVisible: isLabelVisible,
                alignment: const Alignment(0.92, 0.35),
                padding: const EdgeInsets.all(2),
                label: Text(unSeenMsgCount.toString()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: title and time
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Subtitle
                    SizedBox(
                      width:
                          isLabelVisible ? context.width * 0.72 : context.width,
                      child: Text(
                        subtitle.trim(),
                        style: const TextStyle(
                          color: Colors.grey,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
