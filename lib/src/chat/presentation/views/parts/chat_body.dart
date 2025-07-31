import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/app/resources/colors.dart';
import 'package:mustye/core/app/widgets/chat_tile.dart';
import 'package:mustye/core/config/route_config.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/extensions/datetime_extension.dart';
import 'package:mustye/src/chat/data/model/chat_model.dart';
import 'package:provider/provider.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  ValueNotifier<int?> longPressedIndex = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    final chats = provider.user?.chats;

    if (chats!.isEmpty) {
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
            return ValueListenableBuilder(
              valueListenable: longPressedIndex,
              builder: (context, value, child) {
                return ChatTile(
                  title: chat.name,
                  subtitle: chat.lastMsg!,
                  time: chat.lastMsgTime!.lastTimeFormat,
                  image: chat.image,
                  isLabelVisible: chat.unSeenMsgCount != 0,
                  unSeenMsgCount: chat.unSeenMsgCount,
                  tileColor:
                      longPressedIndex.value == index
                          ? context.color.surfaceBright
                          : null,
                  onTap: () {
                    if (longPressedIndex.value != index) {
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
                    }
                    longPressedIndex.value = null;
                  },
                  onLongPress: () {
                    longPressedIndex.value = index;
                  },
                );
              },
            );
          },
        ),
      ],
    );
  
  }
}
