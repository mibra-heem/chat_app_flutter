import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/common/widgets/chat_tile.dart';
import 'package:mustye/core/constants/route_const.dart';
import 'package:mustye/core/extensions/datetime_extension.dart';
import 'package:mustye/src/chat/data/model/chat_model.dart';
import 'package:mustye/src/chat/presentation/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  bool isLabelVisible = true;

  @override
  Widget build(BuildContext context) {
    final chats = Provider.of<UserProvider>(context).user?.chats ?? [];

    if (chats.isEmpty) {
      return const Center(
        child: Text(
          'Start a new chat',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverList.builder(
          itemCount: chats.length,
          itemBuilder: (_, index) {
            final chat = chats[index];
            return ChatTile(
              title: chat.name,
              subtitle: chat.lastMsg!,
              time: chat.lastMsgTime!.lastTimeFormat,
              image: chat.image,
              isLabelVisible: chat.unSeenMsgCount != 0,
              unSeenMsgCount: chat.unSeenMsgCount,
              onTap: () {
                context.read<ChatProvider>().messageSeen(senderUid: chat.uid);
                context.pushNamed(
                  RouteName.message,
                  extra: ChatModel(
                    uid: chat.uid,
                    name: chat.name,
                    email: chat.email,
                    image: chat.image,
                    bio: chat.bio,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
