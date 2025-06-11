import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/app/widgets/arrow_back_button.dart';
import 'package:mustye/core/resources/colors.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';

class AudioCallAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AudioCallAppBar({required this.chat, super.key});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Column(
        children: [
          Text(chat.name, style: const TextStyle(fontSize: 14)),
          const Text(
            'Ringing...',
            style: TextStyle(fontSize: 14, color: Colours.grey600),
          ),
        ],
      ),
      centerTitle: true,
      leading: const ArrowBackButton(),
      titleSpacing: 0,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(IconlyBold.add_user, size: 26),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
