import 'package:flutter/material.dart';
import 'package:mustye/core/common/widgets/gradient_background.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';
import 'package:mustye/src/message/presentation/parts/message_app_bar.dart';
import 'package:mustye/src/message/presentation/parts/message_body.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  static const routeName = '/message';

  @override
  Widget build(BuildContext context) {
    final contact = ModalRoute.of(context)!.settings.arguments! as Contact;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: MessageAppBar(contact: contact),
      body: GradientBackground(
        child: MessageBody(contact: contact),
      ),
    );
  }
}
