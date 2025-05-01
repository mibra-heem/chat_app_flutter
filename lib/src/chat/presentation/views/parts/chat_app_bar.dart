import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Chats'),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: (){}, 
          icon: const Icon(Icons.search, size: 26),
        ),
        IconButton(
          onPressed: (){}, 
          icon: const Icon(IconlyBold.notification),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
