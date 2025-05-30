import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/common/widgets/arrow_back_button.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';

class MessageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MessageAppBar({
  required this.chat,
    super.key,
  });

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        chat.name,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
      leading: const ArrowBackButton(),
      titleSpacing: 0,
      actions: [
        IconButton(
          onPressed: (){}, 
          icon: const Icon(IconlyBold.video, size: 26),
        ),
        IconButton(
          onPressed: (){}, 
          icon: const Icon(IconlyBold.call),
        ),
        IconButton(
          onPressed: (){}, 
          icon: const Icon(Icons.more_vert_rounded),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
