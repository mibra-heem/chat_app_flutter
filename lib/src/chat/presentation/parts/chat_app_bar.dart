import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/res/colors.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colours.primaryColor,
      title: const Text(
        'Chats',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: (){}, 
          icon: const Icon(Icons.search, size: 26, color: Colors.white),
        ),
        IconButton(
          onPressed: (){}, 
          icon: const Icon(IconlyBold.notification, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
