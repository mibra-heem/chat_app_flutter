import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mustye/core/constants/constants.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/resources/media_res.dart';
import 'package:mustye/core/utils/datasource_utils.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/message/features/call/audio/presentation/provider/audio_call_provider.dart';
import 'package:mustye/src/message/features/call/audio/presentation/screens/parts/audio_call_app_bar.dart';
import 'package:mustye/src/message/features/call/audio/presentation/screens/parts/audio_call_bottom_bar.dart';

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen({required this.chat, super.key});
  final Chat chat;

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  late RtcEngine _engine;
  int? _remoteUid;

  @override
  void initState() {
    super.initState();
    _startVoiceCalling();
  }

  // Initializes Agora SDK
  Future<void> _startVoiceCalling() async {
    await AudioCallProvider.requestPermissions();
    await _initializeAgoraVoiceSDK();
    await _setupEventHandlers();
    await _engine.enableAudio();
  }

  // Set up the Agora RTC engine instance
  Future<void> _initializeAgoraVoiceSDK() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(
        appId: agoraAppId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );
  }

  // Register an event handler for Agora RTC
  Future<void> _setupEventHandlers() async {
    final userId = context.currentUser!.uid;
    final userIdInt = userId.hashCode & 0x7fffffff;

    final chatId = widget.chat.uid;
    final channelName = DatasourceUtils.joinIds(userId: userId, chatId: chatId);
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint('Local user ${connection.localUid} joined ..............');
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint('Remote user $remoteUid joined');
          setState(() {
            _remoteUid = remoteUid; // Store remote user ID
          });
        },
        onUserOffline: (
          RtcConnection connection,
          int remoteUid,
          UserOfflineReasonType reason,
        ) async{
          debugPrint('Remote user $remoteUid left');
          setState(() {
            _remoteUid = null; // Remove remote user ID
          });
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

  Future<void> leaveChannel() async{
    await _engine.leaveChannel();
    pop();
  }

  void pop(){
    if (!mounted) return;
    context.pop();
  }

  Future<void> _fetchToken(
    int uid,
    String channelName,
    bool needJoinChannel,
  ) async {
    final client = http.Client();
    try {
      debugPrint('Starting Fetching the temp Token ...........');
      const headers = {'Content-type': 'application/json'};

      final response = await client.post(
        Uri.parse(
          'https://chat-app-laravel-backend-local.up.railway.app/api/agora/token',
        ),
        headers: headers,
        body: jsonEncode({'uid': uid, 'channelName': channelName}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as DataMap;
        final token = data['token'] as String;
        debugPrint('The Temp Token Is : $token...........');

        if (needJoinChannel) {
          // Join a channel
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
          message:
              'Failed to fetch token and statuscode is: ${response.statusCode}',
        );
      }
    } on ServerException catch (e) {
      debugPrint('Error fetching token: $e');
      // Handle failure (e.g., show a snackbar or alert)
    } finally {
      client.close();
    }
  }

  @override
  void dispose() {
    _engine
      ..leaveChannel()
      ..release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AudioCallAppBar(chat: widget.chat),
      body: Stack(
        children: [
          Center(
            child: CircleAvatar(
              radius: 75,
              backgroundImage:
                  widget.chat.image != null
                      ? NetworkImage(widget.chat.image!)
                      : const AssetImage(MediaRes.cartoonTeenageBoyCharacter)
                          as ImageProvider,
            ),
          ),
          Positioned(
            right: context.width * 0.10,
            left: context.width * 0.10,
            bottom: context.width * 0.10,
            child: AudioCallBottomBar(
              onEndCall: () async {
                await leaveChannel();
              },
            ),
          ),
        ],
      ),
    );
  }
}
