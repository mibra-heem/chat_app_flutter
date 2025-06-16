import 'package:flutter/material.dart';
import 'package:mustye/core/resources/colors.dart';
import 'package:mustye/src/message/features/call/audio/domain/entities/incoming_audio_call.dart';

class IncomingAudioCallAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const IncomingAudioCallAppBar({required this.call, super.key});

  final AudioCall call;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Column(
        children: [
          Text(call.callerName, style: const TextStyle(fontSize: 20)),
          Text(
            call.callerEmail,
            style: const TextStyle(fontSize: 16, color: Colours.grey600),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
