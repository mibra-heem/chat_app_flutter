import 'package:flutter/material.dart';
import 'package:mustye/core/app/widgets/gradient_background.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/message/presentation/screen/parts/message_app_bar.dart';
import 'package:mustye/src/message/presentation/screen/parts/message_body.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({
    required this.chat,
    super.key,
  });
  final Chat chat;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MessageAppBar(chat: chat),
      body: GradientBackground(
        child: MessageBody(chat: chat),
      ),
    );
  }
}
