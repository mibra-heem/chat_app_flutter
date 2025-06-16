import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mustye/core/constants/route_const.dart';
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

// import 'dart:async';
// import 'dart:convert';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:http/http.dart' as http;
// import 'package:mustye/core/constants/constants.dart';
// import 'package:mustye/core/constants/route_const.dart';
// import 'package:mustye/core/enums/call.dart';
// import 'package:mustye/core/errors/exception.dart';
// import 'package:mustye/core/extensions/context_extension.dart';
// import 'package:mustye/core/services/dependency_injection.dart';
// import 'package:mustye/core/services/go_router.dart';
// import 'package:mustye/core/utils/datasource_utils.dart';
// import 'package:mustye/src/message/features/call/audio/data/models/incoming_audio_call_model.dart';
// import 'package:mustye/src/message/features/call/audio/domain/entities/incoming_audio_call.dart';
// import 'package:mustye/src/message/features/call/audio/domain/usecases/accept_audio_call.dart';
// import 'package:mustye/src/message/features/call/audio/domain/usecases/activate_incoming_audio_call.dart';
// import 'package:mustye/src/message/features/call/audio/domain/usecases/end_audio_call.dart';
// import 'package:mustye/src/message/features/call/audio/domain/usecases/reject_audio_call.dart';
// import 'package:permission_handler/permission_handler.dart';

// class AudioCallProvider extends ChangeNotifier {
//   AudioCallProvider({
//     required ActivateIncomingAudioCall activateIncomingAudioCall,
//     required AcceptAudioCall acceptAudioCall,
//     required RejectAudioCall rejectAudioCall,
//     required EndAudioCall endAudioCall,
//   }) : _activateIncomingAudioCall = activateIncomingAudioCall,
//        _acceptAudioCall = acceptAudioCall,
//        _rejectAudioCall = rejectAudioCall,
//        _endAudioCall = endAudioCall;

//   final ActivateIncomingAudioCall _activateIncomingAudioCall;
//   final EndAudioCall _endAudioCall;
//   final AcceptAudioCall _acceptAudioCall;
//   final RejectAudioCall _rejectAudioCall;

//   StreamSubscription<QuerySnapshot>? _callSubscription;
//   StreamSubscription<QuerySnapshot>? _rejectCallSubscription;
//   RtcEngine? _engine;
//   int? _remoteUid;

//   int? get remoteUid => _remoteUid;

//   Future<void> initializeAgora(BuildContext context, AudioCall call) async {
//     await requestPermissions();
//     await _initializeAgoraVoiceSDK();
//     await _setupEventHandlers(context, call);
//     await _engine!.enableAudio();
//   }

//   Future<void> requestPermissions() async {
//     await [Permission.microphone].request();
//   }

//   Future<void> _initializeAgoraVoiceSDK() async {
//     _engine = createAgoraRtcEngine();
//     await _engine!.initialize(
//       RtcEngineContext(
//         appId: agoraAppId,
//         channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//       ),
//     );
//   }

//   Future<void> _setupEventHandlers(BuildContext context, AudioCall call) async {
//     final uid = context.currentUser!.uid.hashCode & 0x7fffffff;

//     final userId = call.callerId;
//     final chatId = call.receiverId;

//     final channelName = DatasourceUtils.joinIds(userId: userId, chatId: chatId);

//     _engine!.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           debugPrint('Local user ${connection.localUid} joined ..............');
//           debugPrint('Local user joined the channel ${connection.channelId}..');
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           debugPrint('Remote user $remoteUid joined');
//           _remoteUid = remoteUid;
//           notifyListeners();
//         },
//         onUserOffline: (
//           RtcConnection connection,
//           int remoteUid,
//           UserOfflineReasonType reason,
//         ) async {
//           debugPrint('Remote user $remoteUid left');
//           _remoteUid = null;
//           notifyListeners();
//           await leaveChannelAndPop(context);
//         },
//         onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//           _fetchToken(uid, channelName, false);
//         },
//         onRequestToken: (RtcConnection connection) {
//           _fetchToken(uid, channelName, true);
//         },
//       ),
//     );

//     await _fetchToken(uid, channelName, true);
//   }

//   Future<void> _fetchToken(
//     int uid,
//     String channelName,
//     bool needJoinChannel,
//   ) async {
//     final client = http.Client();
//     try {
//       debugPrint('Starting Fetching the temp Token ...........');
//       const headers = {'Content-type': 'application/json'};

//       final response = await client.post(
//         Uri.parse(
//           'https://chat-app-laravel-backend-local.up.railway.app/api/agora/token',
//         ),
//         headers: headers,
//         body: jsonEncode({'uid': uid, 'channelName': channelName}),
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body) as Map<String, dynamic>;
//         final token = data['token'] as String;
//         debugPrint('The Temp Token Is : $token...........');

//         if (needJoinChannel) {
//           await _engine!.joinChannel(
//             uid: uid,
//             token: token,
//             channelId: channelName,
//             options: const ChannelMediaOptions(
//               autoSubscribeAudio: true,
//               publishMicrophoneTrack: true,
//               clientRoleType: ClientRoleType.clientRoleBroadcaster,
//             ),
//           );
//         } else {
//           await _engine!.renewToken(token);
//         }
//       } else {
//         throw ServerException(
//           message:
//               'Failed to fetch token and statuscode is: ${response.statusCode}',
//         );
//       }
//     } on ServerException catch (e) {
//       debugPrint('Error fetching token: $e');
//     } finally {
//       client.close();
//     }
//   }

//   Future<void> leaveChannelAndPop(BuildContext context) async {
//     debugPrint('leaveChannelAndPop() .......');
//     await _engine?.leaveChannel();

//     if (context.mounted) {
//       context.pop();
//     }
//   }

// Future<void> leaveChannelAndRelease() async {
//   debugPrint('leaveChannelAndRelease() .......');
//   if (_engine != null) {
//     await _engine!.leaveChannel();
//     await _engine!.release();
//   }
// }

//   Future<void> activateIncomingAudioCall(AudioCall call) async {
//     final result = await _activateIncomingAudioCall(call);

//     result.fold(
//       (failure) => debugPrint(failure.errorMessage),
//       (_) => debugPrint('....... activateIncomingAudioCall success ........'),
//     );
//   }

//   Future<void> acceptAudioCall(AudioCall call) async {
//     final result = await _acceptAudioCall(call);

//     result.fold(
//       (failure) => debugPrint(failure.errorMessage),
//       (_) => debugPrint('......... acceptAudioCall success ..........'),
//     );
//   }

//   Future<void> rejectAudioCall(AudioCall call) async {
//     final result = await _rejectAudioCall(call);

//     result.fold(
//       (failure) => debugPrint(failure.errorMessage),
//       (_) => debugPrint('......... rejectAudioCall success ..........'),
//     );
//   }

//   Future<void> endAudioCall(AudioCall call) async {
//     final result = await _endAudioCall(call);

//     result.fold(
//       (failure) => debugPrint(failure.errorMessage),
//       (_) => debugPrint('......... endAudioCall success ..........'),
//     );
//   }

//   void listeningForCall(BuildContext context) {
//     debugPrint('listeningForCall triggered ................');
//     _callSubscription = sl<FirebaseFirestore>()
//         .collection('calls')
//         .where('receiverId', isEqualTo: context.currentUser!.uid)
//         .where('status', isEqualTo: CallStatus.ringing.name)
//         .snapshots()
//         .listen((snapshot) {
//           for (final doc in snapshot.docs) {
//             final data = doc.data();
//             final call = AudioCallModel.fromMap(data);
//             if (doc.exists &&
//                 call.isCallOn == true &&
//                 call.status == CallStatus.ringing) {
//               debugPrint(
//                 'Listening the change isCallOn is true ................',
//               );
//               rootNavigatorKey.currentContext?.pushNamed(
//                 RouteName.incomingAudioCall,
//                 extra: call,
//               );
//             }
//           }
//         });
//   }

//   void listeningToCallReject(BuildContext context) {
//     debugPrint('🔔 listeningToCallReject triggered...');

//     final currentUserId = context.currentUser?.uid;
//     if (currentUserId == null) {
//       debugPrint('❌ Current user ID is null. Aborting reject listener.');
//       return;
//     }

//     _rejectCallSubscription = sl<FirebaseFirestore>()
//         .collection('calls')
//         .where('callerId', isEqualTo: currentUserId)
//         .where('status', isEqualTo: CallStatus.rejected.name)
//         .where('isCallOn', isEqualTo: true)
//         .limit(1)
//         .snapshots()
//         .listen((snapshot) async {
//           if (snapshot.docs.isEmpty) {
//             debugPrint('🚫 No rejected calls found.');
//             return;
//           }

//           final doc = snapshot.docs.first;
//           final data = doc.data();
//           final call = AudioCallModel.fromMap(data);

//           debugPrint('📞 Call rejected detected for call ID: ${call.uid}');
//           await leaveChannelAndRelease();

//           // Update the isCallOn flag only once
//           await sl<FirebaseFirestore>()
//               .collection('calls')
//               .doc(call.uid)
//               .update({'isCallOn': false});

//           rootNavigatorKey.currentContext?.pop();
//         });
//   }

//   void stopListening() {
//     _callSubscription?.cancel();
//     _rejectCallSubscription?.cancel();
//   }

//   @override
//   void dispose() {
//     stopListening();
//     leaveChannelAndRelease();
//     super.dispose();
//   }
// }
