import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mustye/core/constants/route_const.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/services/go_router.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/message/features/audio_call/data/models/incoming_audio_call_model.dart';
import 'package:mustye/src/message/features/audio_call/domain/entities/incoming_audio_call.dart';
import 'package:mustye/src/message/features/audio_call/domain/usecases/activate_incoming_audio_call.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioCallProvider extends ChangeNotifier {
  AudioCallProvider(ActivateIncomingAudioCall activateIncomingAudioCall)
    : _activateIncomingAudioCall = activateIncomingAudioCall;

  final ActivateIncomingAudioCall _activateIncomingAudioCall;

  StreamSubscription<DocumentSnapshot>? _subscription;

  // Requests microphone permission
  static Future<void> requestPermissions() async {
    await [Permission.microphone].request();
  }

  Future<void> activateIncomingAudioCall(IncomingAudioCall call) async {
    final result = await _activateIncomingAudioCall(call);

    result.fold(
      (failure) {
        debugPrint(failure.errorMessage);
      },
      (_) {
        debugPrint('.................. success ............................');
      },
    );
  }

  void startListening(BuildContext context) {
    debugPrint('startListening triggered ................');

    _subscription = FirebaseFirestore.instance
        .collection('incoming_audio_calls')
        .doc(context.currentUser!.uid) // sl<FirebaseAuth>()
        .snapshots()
        .listen((snapshot) {
          final data = snapshot.data();
          if (data != null) {
            final call = IncomingAudioCallModel.fromMap(data);
            if (snapshot.exists && call.isCalling == true) {
              // final channelName = data['channelName'];
              debugPrint(
                'Listening the change isCalling is true ................',
              );

              final chat = Chat(uid: call.callerId, email: '', name: '');
              // context.pushNamed(RouteName.audioCall, extra: chat);

              rootNavigatorKey.currentContext?.pushNamed(
                RouteName.audioCall,
                extra: chat,
              );
            }
          }
        });
  }

  void stopListening() {
    _subscription?.cancel();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}
