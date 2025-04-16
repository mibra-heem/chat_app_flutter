import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/common/widgets/chat_tile.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/contact/data/model/contact_model.dart';
import 'package:mustye/src/message/presentation/screen/message_screen.dart';
import 'package:provider/provider.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  @override
  Widget build(BuildContext context) {
    if (kDebugMode)
      print('........ ChatView : ${context.currentUser!.contacts} .........');
    return Consumer<UserProvider>(
      builder: (_, provider, child) {
        final contacts = provider.user!.contacts;

        return CustomScrollView(
          slivers: [
            SliverList.builder(
              itemCount: contacts.length,
              itemBuilder: (_, index) {
                final contact = contacts[index];
                return ChatTile(
                  title: contact.fullName,
                  subtitle: 'last message will be shown here...',
                  time: '3:59 am',
                  image: contact.image,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MessageScreen.routeName,
                      arguments: ContactModel(
                        uid: contact.uid,
                        fullName: contact.fullName,
                        email: contact.email,
                        image: contact.image,
                        bio: contact.bio,
                        lastSeen: contact.lastSeen,
                        isOnline: contact.isOnline,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
