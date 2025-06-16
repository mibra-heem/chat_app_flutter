import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/app/widgets/arrow_back_button.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/resources/colors.dart';
import 'package:mustye/src/message/features/call/audio/domain/entities/incoming_audio_call.dart';

class AudioCallAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AudioCallAppBar({required this.call, super.key});

  final AudioCall call;

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser!;
    final name =
        user.uid == call.receiverId ? call.callerName : call.receiverName;
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Column(
        children: [
          Text(name, style: const TextStyle(fontSize: 14)),
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
