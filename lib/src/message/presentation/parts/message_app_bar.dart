import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/common/widgets/arrow_back_button.dart';
import 'package:mustye/core/res/colors.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';

class MessageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MessageAppBar({
  required this.contact,
    super.key,
  });

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colours.primaryColor,
      title: Text(
        contact.fullName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: const ArrowBackButton(),
      leadingWidth: 30,
      actions: [
        IconButton(
          onPressed: (){}, 
          icon: const Icon(IconlyBold.video, size: 26, color: Colors.white),
        ),
        IconButton(
          onPressed: (){}, 
          icon: const Icon(IconlyBold.call, color: Colors.white),
        ),
        IconButton(
          onPressed: (){}, 
          icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
