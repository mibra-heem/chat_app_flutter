import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mustye/core/constants/route_const.dart';
import 'package:mustye/core/enums/call.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/resources/media_res.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/src/message/features/call/audio/data/models/incoming_audio_call_model.dart';
import 'package:mustye/src/message/features/call/audio/domain/entities/incoming_audio_call.dart';
import 'package:mustye/src/message/features/call/audio/presentation/provider/audio_call_provider.dart';
import 'package:mustye/src/message/features/call/audio/presentation/screens/parts/incoming_audio_call_app_bar.dart';
import 'package:mustye/src/message/features/call/audio/presentation/screens/parts/incoming_audio_call_bottom_bar.dart';

class IncomingAudioCallScreen extends StatelessWidget {
  const IncomingAudioCallScreen({required this.call, super.key});
  final AudioCall call;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: IncomingAudioCallAppBar(call: call),
      body: Stack(
        children: [
          Center(
            child: CircleAvatar(
              radius: 75,
              backgroundImage:
                  call.callerImage != null
                      ? NetworkImage(call.callerImage!)
                      : const AssetImage(MediaRes.cartoonTeenageBoyCharacter)
                          as ImageProvider,
            ),
          ),
          Positioned(
            right: context.width * 0.12,
            left: context.width * 0.12,
            bottom: context.width * 0.12,
            child: IncomingAudioCallBottomBar(
              onAcceptCall: () {
                sl<AudioCallProvider>().acceptAudioCall(
                  (call as AudioCallModel).copyWith(
                    isCallOn: true,
                    status: CallStatus.accepted,
                  ),
                );
                context.pushReplacementNamed(RouteName.audioCall, extra: call);
              },
              onRejectCall: () {
                sl<AudioCallProvider>().rejectAudioCall(
                  (call as AudioCallModel).copyWith(
                    isCallOn: true,
                    status: CallStatus.rejected,
                    endedAt: Timestamp.now().toDate(),
                  ),
                );
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
