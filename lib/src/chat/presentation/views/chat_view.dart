import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/app/widgets/chat_tile.dart';
import 'package:mustye/core/config/route_config.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/extensions/datetime_extension.dart';
import 'package:mustye/src/chat/data/model/chat_model.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/chat/presentation/views/parts/chat_app_bar.dart';
import 'package:mustye/src/chat/presentation/views/widgets/add_contacts_floating_button.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  List<String> longPressedTiles = [];

  List<Chat> get deleteChats {
    final chats = context.read<UserProvider>().user?.chats ?? [];
    return chats.where((chat) => longPressedTiles.contains(chat.uid)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final chats = provider.user?.chats.where((chat)=> chat.lastMsg != null).toList() ?? [];

    debugPrint('chats => $chats');
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: const AddContactsFloatingButton(),
      appBar: ChatAppBar(
        deleteChats: deleteChats,
        longPressedTiles: longPressedTiles,
      ),
      body:
          chats.isEmpty
              ? const Center(
                child: Text(
                  'Start a new chat',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return ChatTile(
                    title: chat.name,
                    subtitle: chat.lastMsg ?? '',
                    time: chat.lastMsgTime!.lastTimeFormat,
                    image: chat.image,
                    isLabelVisible: chat.unSeenMsgCount != 0,
                    unSeenMsgCount: chat.unSeenMsgCount,
                    tileColor:
                        longPressedTiles.contains(chat.uid)
                            ? context.color.surfaceBright
                            : null,
                    onTap: () {
                      if (!longPressedTiles.contains(chat.uid)) {
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
                      setState(() {
                        longPressedTiles.remove(chat.uid);
                      });
                    },
                    onLongPress: () {
                      setState(() {
                        if (longPressedTiles.contains(chat.uid)) {
                          longPressedTiles.remove(chat.uid);
                        } else {
                          longPressedTiles.add(chat.uid);
                        }
                      });
                    },
                  );
                  ;
                },
              ),
    );
  }
}

/*
CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate((_, index) {
                      final chat = chats[index];
                      return ChatTile(
                        title: chat.name,
                        subtitle: chat.lastMsg!,
                        time: chat.lastMsgTime!.lastTimeFormat,
                        image: chat.image,
                        isLabelVisible: chat.unSeenMsgCount != 0,
                        unSeenMsgCount: chat.unSeenMsgCount,
                        tileColor:
                            longPressedTiles.contains(chat.uid)
                                ? context.color.surfaceBright
                                : context.color.surface,
                        onTap: () {
                          if (!longPressedTiles.contains(chat.uid)) {
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
                          setState(() {
                            longPressedTiles.remove(chat.uid);
                          });
                        },
                        onLongPress: () {
                          setState(() {
                            if (longPressedTiles.contains(chat.uid)) {
                              longPressedTiles.remove(chat.uid);
                            } else {
                              longPressedTiles.add(chat.uid);
                            }
                          });
                        },
                      );
                    }, childCount: chats.length),
                  ),
                ],
              )
*/
