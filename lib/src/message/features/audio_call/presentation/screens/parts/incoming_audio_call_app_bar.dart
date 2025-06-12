import 'package:flutter/material.dart';
import 'package:mustye/core/resources/colors.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';

class IncomingAudioCallAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const IncomingAudioCallAppBar({required this.chat, super.key});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Column(
        children: [
          Text(chat.name, style: const TextStyle(fontSize: 20)),
          Text(
            chat.email,
            style: const TextStyle(fontSize: 16, color: Colours.grey600),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
