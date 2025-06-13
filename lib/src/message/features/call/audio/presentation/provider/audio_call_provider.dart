import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mustye/core/constants/route_const.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/services/go_router.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/message/features/call/audio/data/models/incoming_audio_call_model.dart';
import 'package:mustye/src/message/features/call/audio/domain/entities/incoming_audio_call.dart';
import 'package:mustye/src/message/features/call/audio/domain/usecases/activate_incoming_audio_call.dart';
import 'package:mustye/src/message/features/call/audio/domain/usecases/deactivate_incoming_audio_call.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioCallProvider extends ChangeNotifier {
  AudioCallProvider({
    required ActivateIncomingAudioCall activateIncomingAudioCall,
    required DeactivateIncomingAudioCall deactivateIncomingAudioCall,
  }) : _activateIncomingAudioCall = activateIncomingAudioCall,
       _deactivateIncomingAudioCall = deactivateIncomingAudioCall;

  final ActivateIncomingAudioCall _activateIncomingAudioCall;
  final DeactivateIncomingAudioCall _deactivateIncomingAudioCall;

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
        debugPrint('........... activateIncomingAudioCall success ...........');
      },
    );
  }

  Future<void> deactivateIncomingAudioCall() async {
    debugPrint('...... calling deactivateIncomingAudioCall in provider ......');

    final result = await _deactivateIncomingAudioCall();

    result.fold(
      (failure) {
        debugPrint(failure.errorMessage);
      },
      (_) {
        debugPrint('......... deactivateIncomingAudioCall success ..........');
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
              debugPrint(
                'Listening the change isCalling is true ................',
              );
              rootNavigatorKey.currentContext?.pushNamed(
                RouteName.incomingAudioCall,
                extra: call,
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
