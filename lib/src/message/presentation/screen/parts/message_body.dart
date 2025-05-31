import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mustye/core/app/views/loading_view.dart';
import 'package:mustye/core/app/widgets/message_tile.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/extensions/datetime_extension.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/core/utils/stream_utils.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/chat/presentation/provider/chat_provider.dart';
import 'package:mustye/src/message/domain/entity/message.dart';
import 'package:mustye/src/message/presentation/provider/message_provider.dart';
import 'package:mustye/src/message/presentation/screen/parts/message_foot.dart';
import 'package:provider/provider.dart';

class MessageBody extends StatefulWidget {
  const MessageBody({required this.chat, super.key});

  final Chat chat;

  @override
  State<MessageBody> createState() => _MessageBodyState();
}

class _MessageBodyState extends State<MessageBody> {

  List<dynamic> mergedMsgAndLabelList(List<Message> messages) {
    final mergedList = <dynamic>[];
    String? existedLabel;

    for (final message in messages) {
      final dayLabel = message.msgTime.relativeDayLabel;

      if (dayLabel != existedLabel) {
        mergedList.add(dayLabel);
        existedLabel = dayLabel;
      }
      mergedList.add(message);
    }
    return mergedList.reversed.toList();
  }

  final MessageProvider _messageProvider = sl<MessageProvider>();
  
  @override
  void initState() {
    super.initState();
    debugPrint('........ Activating the chat .......');
    context.read<ChatProvider>().messageSeen(senderUid: widget.chat.uid);

    _messageProvider.setActiveChatId(activeChatId: widget.chat.uid);
    debugPrint('........ Chat Activated .......');
  }

  @override
  void dispose() {
    debugPrint('........ De-activating the chat .......');

    _messageProvider.setActiveChatId(activeChatId: null);

    debugPrint('........ Chat De-activated .......');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<List<Message>>(
          stream: StreamUtils.getMessages(widget.chat.uid),
          builder: (context, snapshot) {
            if (kDebugMode) print('....... Messsages Streaming .......');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingView();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No messages yet.'));
            }

            final messages = snapshot.data!;
            final currentUserId = context.currentUser!.uid;

            debugPrint(messages.toString());

            final mergedList = mergedMsgAndLabelList(messages);

            return Padding(
              padding: const EdgeInsets.only(bottom: 75),
              child: CustomScrollView(
                shrinkWrap: true,
                reverse: true,
                slivers: [
                  SliverList.builder(
                    itemCount: mergedList.length,
                    itemBuilder: (context, index) {
                      final item = mergedList[index];

                      if (item is String) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      } else if (item is Message) {
                        final isCurrentUser = currentUserId == item.senderId;
                        debugPrint(item.toString());
                        return MessageTile(
                          message: item.msg,
                          time: item.msgTime.timePeriodFormat,
                          isSeen: item.isSeen,
                          isCurrentUser: isCurrentUser,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            );
          },
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: MessageFoot(chat: widget.chat),
        ),
      ],
    );
  }
}
