import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/chat/presentation/provider/chat_provider.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({
    required this.longPressedTiles,
    super.key,
    this.deleteChats = const [],
  });

  final List<Chat> deleteChats;
  final List<String> longPressedTiles;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Chats'),
      automaticallyImplyLeading: false,
      actions:
          deleteChats.isNotEmpty
              ? [
                IconButton(
                  onPressed: () {
                    context.read<ChatProvider>().deleteChatHandler(
                      chats: deleteChats,
                    );

                    longPressedTiles.clear();
                  },
                  icon: const Icon(Icons.delete, size: 26),
                ),
              ]
              : [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.search),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.bell),
                ),
              ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
