import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mustye/core/constants/api_const.dart';
import 'package:mustye/core/constants/constants.dart';
import 'package:mustye/core/enums/call.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/resources/media_res.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/core/utils/datasource_utils.dart';
import 'package:mustye/core/utils/stream_utils.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/message/features/call/audio/data/models/incoming_audio_call_model.dart';
import 'package:mustye/src/message/features/call/audio/presentation/provider/audio_call_provider.dart';
import 'package:mustye/src/message/features/call/audio/presentation/screens/parts/audio_call_app_bar.dart';
import 'package:mustye/src/message/features/call/audio/presentation/screens/parts/audio_call_bottom_bar.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen({required this.call, super.key});
  final AudioCallModel call;

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  late RtcEngine _engine;
  int? _remoteUid;
  late ValueNotifier<AudioCallModel> callNotifier;

  @override
  void initState() {
    super.initState();
    callNotifier = ValueNotifier(widget.call);
    _startVoiceCalling();
    _listenToCallUpdates();
  }

  void _listenToCallUpdates() {
    StreamUtils.getCallsData.listen((event) {
      if (event is AudioCallModel && event.uid == widget.call.uid) {
        callNotifier.value = event;
      }
    });
  }

  Future<void> _startVoiceCalling() async {
    await [Permission.microphone].request();
    await _initializeAgoraVoiceSDK();
    await _setupEventHandlers();
    await _engine.enableAudio();
  }

  Future<void> _initializeAgoraVoiceSDK() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(
        appId: agoraAppId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );
  }

  Future<void> _setupEventHandlers() async {
    final userIdInt = context.currentUser!.uid.hashCode & 0x7fffffff;
    final channelName = DatasourceUtils.joinIds(
      userId: widget.call.callerId,
      chatId: widget.call.receiverId,
    );

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint('✅ Local user joined channel ${connection.channelId}');
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint('👤 Remote user $remoteUid joined');
          _remoteUid = remoteUid;
        },
        onUserOffline: (
          RtcConnection connection,
          int remoteUid,
          UserOfflineReasonType reason,
        ) async {
          debugPrint('👋 Remote user $remoteUid left');
          _remoteUid = null;
          await leaveChannel();
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          _fetchToken(userIdInt, channelName, false);
        },
        onRequestToken: (RtcConnection connection) {
          _fetchToken(userIdInt, channelName, true);
        },
      ),
    );

    await _fetchToken(userIdInt, channelName, true);
  }

  Future<void> _fetchToken(
    int uid,
    String channelName,
    bool needJoinChannel,
  ) async {
    final client = http.Client();
    try {
      final response = await client.post(
        Uri.parse(ApiConst.baseUrl + ApiConst.generateAgoraTokenUrl),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({'uid': uid, 'channelName': channelName}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as DataMap;
        final token = data['token'] as String;
        if (needJoinChannel) {
          await _engine.joinChannel(
            uid: uid,
            token: token,
            channelId: channelName,
            options: const ChannelMediaOptions(
              autoSubscribeAudio: true,
              publishMicrophoneTrack: true,
              clientRoleType: ClientRoleType.clientRoleBroadcaster,
            ),
          );
        } else {
          await _engine.renewToken(token);
        }
      } else {
        throw ServerException(
          message: 'Failed to fetch token (${response.statusCode})',
        );
      }
    } on ServerException catch (e) {
      debugPrint('❌ Error fetching token: $e');
    } finally {
      client.close();
    }
  }

  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
    if (mounted) context.pop();
  }

  @override
  void dispose() {
    _engine
      ..leaveChannel()
      ..release();
    callNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.currentUser!;
    return ValueListenableBuilder<AudioCallModel>(
      valueListenable: callNotifier,
      builder: (_, call, __) {
        final image =
            currentUser.uid == call.receiverId
                ? call.callerImage
                : call.receiverImage;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AudioCallAppBar(call: call),
          body: Stack(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage:
                      image != null
                          ? NetworkImage(image)
                          : const AssetImage(
                                MediaRes.cartoonTeenageBoyCharacter,
                              )
                              as ImageProvider,
                ),
              ),
              Positioned(
                left: context.width * 0.10,
                right: context.width * 0.10,
                bottom: context.width * 0.10,
                child: AudioCallBottomBar(
                  onEndCall: () async {
                    await leaveChannel();
                    final provider = sl<AudioCallProvider>();

                    if (call.status == CallStatus.accepted) {
                      await provider.endAudioCall(
                        call.copyWith(
                          isCallOn: false,
                          status: CallStatus.ended,
                          endedAt: Timestamp.now().toDate(),
                        ),
                      );
                    } else {
                      await provider.cancelAudioCall(
                        call.copyWith(
                          status: CallStatus.cancelled,
                          endedAt: Timestamp.now().toDate(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
