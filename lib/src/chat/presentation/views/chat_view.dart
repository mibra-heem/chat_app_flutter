import 'package:flutter/material.dart';
import 'package:mustye/core/common/widgets/gradient_background.dart';
import 'package:mustye/src/chat/presentation/views/parts/chat_app_bar.dart';
import 'package:mustye/src/chat/presentation/views/parts/chat_body.dart';
import 'package:mustye/src/chat/presentation/views/widgets/add_contacts_floating_button.dart';
import 'package:mustye/src/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('........... Chat View ...........');
    final provider = Provider.of<DashboardProvider>(context);
    return PopScope(
      canPop: provider.canPop,
      child: const Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButton: AddContactsFloatingButton(),
        appBar: ChatAppBar(),
        body: GradientBackground(child: ChatBody()),
      ),
    );
  }
}
