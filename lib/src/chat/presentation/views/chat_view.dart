import 'package:flutter/material.dart';
import 'package:mustye/core/common/widgets/gradient_background.dart';
import 'package:mustye/src/chat/presentation/parts/chat_app_bar.dart';
import 'package:mustye/src/chat/presentation/parts/chat_body.dart';
import 'package:mustye/src/chat/presentation/widgets/add_contacts_floating_button.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      floatingActionButton: AddContactsFloatingButton(),
      appBar: ChatAppBar(),
      body: GradientBackground(
        child: ChatBody(),
      ),
    );
  }
}
