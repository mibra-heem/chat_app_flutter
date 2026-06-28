import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mustye/core/app/resources/colors.dart';

class AudioCallBottomBar extends StatelessWidget {
  const AudioCallBottomBar({super.key, this.onEndCall});

  final VoidCallback? onEndCall;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colours.grey900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(LucideIcons.moreHorizontal),
          ),
          IconButton(onPressed: () {}, icon: const Icon(LucideIcons.volume2)),
          IconButton(onPressed: () {}, icon: const Icon(LucideIcons.mic)),
          Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onEndCall,
              icon: const Icon(LucideIcons.phoneOff),
            ),
          ),
        ],
      ),
    );
  }
}
