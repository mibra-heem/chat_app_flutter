import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mustye/core/common/widgets/gradient_background.dart';
import 'package:mustye/src/chat/presentation/views/parts/chat_app_bar.dart';
import 'package:mustye/src/chat/presentation/views/parts/chat_body.dart';
import 'package:mustye/src/chat/presentation/views/widgets/add_contacts_floating_button.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    if(kDebugMode) print('........ ChatView building .......');

    return const Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: AddContactsFloatingButton(),
      appBar: ChatAppBar(),
      body: GradientBackground(
        child: ChatBody(),
      ),
    );
  }
}
