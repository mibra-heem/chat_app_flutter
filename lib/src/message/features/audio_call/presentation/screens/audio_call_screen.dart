import 'package:flutter/material.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/resources/media_res.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/message/features/audio_call/presentation/screens/parts/audio_call_app_bar.dart';
import 'package:mustye/src/message/features/audio_call/presentation/screens/parts/audio_call_bottom_bar.dart';

class AudioCallScreen extends StatelessWidget {
  const AudioCallScreen({required this.chat, super.key});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AudioCallAppBar(chat: chat),
      body: Stack(
        children: [
          Center(
            child: CircleAvatar(
            radius: 75,
            backgroundImage:
                chat.image != null
                    ? NetworkImage(chat.image!)
                    : const AssetImage(MediaRes.cartoonTeenageBoyCharacter)
                        as ImageProvider,
                    ),
          ),
          Positioned(
            right: context.width * 0.10,
            left: context.width * 0.10,
            bottom: context.width * 0.10,
            child: const AudioCallBottomBar(),
          ),
        ],
      ),
    );
  }
}
