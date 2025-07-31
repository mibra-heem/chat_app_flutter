import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/app/resources/colors.dart';

class AudioCallBottomBar extends StatelessWidget {
  const AudioCallBottomBar({
    super.key,
    this.onEndCall,
  });

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
            icon: const Icon(Icons.more_horiz_outlined),
          ),
          IconButton(onPressed: () {}, icon: const Icon(IconlyBold.volume_up)),
          IconButton(onPressed: () {}, icon: const Icon(IconlyBold.voice)),
          Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onEndCall,
              icon: const Icon(IconlyBold.call),
            ),
          ),
        ],
      ),
    );
  }
}
