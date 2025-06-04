import 'package:flutter/material.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({required this.chat, super.key});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Video Call Screen'),
      ),
    );
  }
}
