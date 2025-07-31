import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mustye/core/config/route_config.dart';
import 'package:mustye/core/enums/call.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/core/services/go_router.dart';
import 'package:mustye/src/message/features/call/audio/data/models/incoming_audio_call_model.dart';
import 'package:mustye/src/message/features/call/audio/domain/entities/incoming_audio_call.dart';
import 'package:mustye/src/message/features/call/audio/domain/usecases/accept_audio_call.dart';
import 'package:mustye/src/message/features/call/audio/domain/usecases/activate_incoming_audio_call.dart';
import 'package:mustye/src/message/features/call/audio/domain/usecases/end_audio_call.dart';
import 'package:mustye/src/message/features/call/audio/domain/usecases/reject_audio_call.dart';

class AudioCallProvider extends ChangeNotifier {
  AudioCallProvider({
    required ActivateIncomingAudioCall activateIncomingAudioCall,
    required AcceptAudioCall acceptAudioCall,
    required RejectAudioCall rejectAudioCall,
    required EndAudioCall endAudioCall,
  }) : _activateIncomingAudioCall = activateIncomingAudioCall,
       _acceptAudioCall = acceptAudioCall,
       _rejectAudioCall = rejectAudioCall,
       _endAudioCall = endAudioCall;

  final ActivateIncomingAudioCall _activateIncomingAudioCall;
  final EndAudioCall _endAudioCall;
  final AcceptAudioCall _acceptAudioCall;
  final RejectAudioCall _rejectAudioCall;

  StreamSubscription<QuerySnapshot>? _callSubscription;
  StreamSubscription<QuerySnapshot>? _rejectCallSubscription;
  StreamSubscription<QuerySnapshot>? _callerHangupSubscription;

  Future<void> activateIncomingAudioCall(AudioCall call) async {
    final result = await _activateIncomingAudioCall(call);

    result.fold(
      (failure) => debugPrint(failure.errorMessage),
      (_) => debugPrint('....... activateIncomingAudioCall success ........'),
    );
  }

  Future<void> cancelAudioCall(AudioCall call) async {
    final result = await _endAudioCall(call);

    result.fold(
      (failure) => debugPrint(failure.errorMessage),
      (_) => debugPrint('......... cancelAudioCall success ..........'),
    );
  }

  Future<void> endAudioCall(AudioCall call) async {
    final result = await _endAudioCall(call);

    result.fold(
      (failure) => debugPrint(failure.errorMessage),
      (_) => debugPrint('......... endAudioCall success ..........'),
    );
  }

  Future<void> acceptAudioCall(AudioCall call) async {
    final result = await _acceptAudioCall(call);

    result.fold(
      (failure) => debugPrint(failure.errorMessage),
      (_) => debugPrint('......... acceptAudioCall success ..........'),
    );
  }

  Future<void> rejectAudioCall(AudioCall call) async {
    final result = await _rejectAudioCall(call);

    result.fold(
      (failure) => debugPrint(failure.errorMessage),
      (_) => debugPrint('......... rejectAudioCall success ..........'),
    );
  }

  void listeningForCall(BuildContext context) {
    debugPrint('listeningForCall triggered ................');
    _callSubscription = sl<FirebaseFirestore>()
        .collection('calls')
        .where('receiverId', isEqualTo: context.currentUser!.uid)
        .where('status', isEqualTo: CallStatus.ringing.name)
        .snapshots()
        .listen((snapshot) {
          for (final doc in snapshot.docs) {
            final data = doc.data();
            final call = AudioCallModel.fromMap(data);
            if (doc.exists &&
                call.isCallOn == true &&
                call.status == CallStatus.ringing) {
              debugPrint(
                'Listening the change isCallOn is true ................',
              );
              rootNavigatorKey.currentContext?.pushNamed(
                RouteName.incomingAudioCall,
                extra: call,
              );
            }
          }
        });
  }

  void listeningToCallReject(BuildContext context) {
    debugPrint('🔔 listeningToCallReject triggered...');

    final currentUserId = context.currentUser?.uid;
    if (currentUserId == null) {
      debugPrint('❌ Current user ID is null. Aborting reject listener.');
      return;
    }

    _rejectCallSubscription = sl<FirebaseFirestore>()
        .collection('calls')
        .where('callerId', isEqualTo: currentUserId)
        .where('status', isEqualTo: CallStatus.rejected.name)
        .where('isCallOn', isEqualTo: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) async {
          if (snapshot.docs.isEmpty) {
            debugPrint('🚫 No rejected calls found.');
            return;
          }

          final doc = snapshot.docs.first;
          final data = doc.data();
          final call = AudioCallModel.fromMap(data);

          debugPrint('📞 Call rejected detected for call ID: ${call.uid}');

          // Update the isCallOn flag only once
          await sl<FirebaseFirestore>()
              .collection('calls')
              .doc(call.uid)
              .update({'isCallOn': false});

          rootNavigatorKey.currentContext?.pop();
        });
  }

  void listenToCallerHangupBeforeAnswer(BuildContext context) {
    debugPrint('👂 Listening for caller hangup...');

    final currentUserId = context.currentUser?.uid;
    if (currentUserId == null) {
      debugPrint('❌ Current user ID is null. Aborting caller hangup listener.');
      return;
    }

    _callerHangupSubscription = sl<FirebaseFirestore>()
        .collection('calls')
        .where('receiverId', isEqualTo: currentUserId)
        .where('status', isEqualTo: CallStatus.cancelled.name)
        .where('isCallOn', isEqualTo: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) async{
          if (snapshot.docs.isEmpty) {
            debugPrint('🚫 No rejected calls found.');
            return;
          }

          final doc = snapshot.docs.first;
          final data = doc.data();
          final call = AudioCallModel.fromMap(data);

          debugPrint('📞 Call rejected detected for call ID: ${call.uid}');

          // Update the isCallOn flag only once
          await sl<FirebaseFirestore>()
              .collection('calls')
              .doc(call.uid)
              .update({'isCallOn': false});

          rootNavigatorKey.currentContext?.pop();
        });
  }

  void stopListening() {
    _callSubscription?.cancel();
    _rejectCallSubscription?.cancel();
    _callerHangupSubscription?.cancel();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}
