import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mustye/core/constants/route_const.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/resources/media_res.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/message/features/audio_call/presentation/screens/parts/incoming_audio_call_app_bar.dart';
import 'package:mustye/src/message/features/audio_call/presentation/screens/parts/incoming_audio_call_bottom_bar.dart';

class IncomingAudioCallScreen extends StatelessWidget {
  const IncomingAudioCallScreen({required this.chat, super.key});
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: IncomingAudioCallAppBar(chat: chat),
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
            right: context.width * 0.12,
            left: context.width * 0.12,
            bottom: context.width * 0.12,
            child: IncomingAudioCallBottomBar(
              onAcceptCall: (){
                context.pushNamed(RouteName.audioCall, extra: chat);
              },
              onRejectCall: (){
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
