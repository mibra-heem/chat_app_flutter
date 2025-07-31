import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mustye/core/app/resources/colors.dart';
import 'package:mustye/core/app/views/loading_view.dart';
import 'package:mustye/core/app/widgets/message_tile.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/extensions/datetime_extension.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/core/utils/stream_utils.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
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

  @override
  void initState() {
    super.initState();
    print(widget.chat.uid);
    context.chatProvider.messageSeen(senderUid: widget.chat.uid);
    sl<MessageProvider>().setActiveChatId(activeChatId: widget.chat.uid);
  }

  @override
  void dispose() {
    sl<MessageProvider>().setActiveChatId(activeChatId: null);
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
            final mergedList = mergedMsgAndLabelList(messages);

            // getSelectedMessages(messages);

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
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: context.color.tertiaryContainer.withAlpha(
                                150,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item,
                              style: context.text.labelSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      } else if (item is Message) {
                        final isCurrentUser = currentUserId == item.senderId;
                        return Selector<MessageProvider, SDMap>(
                          selector:
                              (_, provider) => {
                                'isSelected': provider.selectedMessages
                                    .contains(item.uid),
                                'length': provider.selectedMessages.length,
                              },
                          builder: (context, selectedData, _) {
                            final isSelected =
                                selectedData['isSelected'] as bool;
                            final length = selectedData['length'] as int;
                            final provider =
                                context.read<MessageProvider>()
                                  ..messages = messages;

                            return Container(
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? context.color.surfaceContainer
                                        : null,
                              ),
                              child: MessageTile(
                                message: item.msg,
                                time: item.msgTime.timePeriodFormat,
                                isSeen: item.isSeen,
                                isCurrentUser: isCurrentUser,
                                onTap: () {
                                  print('length => $length ');

                                  // print('${provider.selectedMessages} ');

                                  if (isSelected) {
                                    provider.removeSelectedMessage(item.uid);
                                  } else {
                                      print('tapped ');

                                    if (length >= 1) {
                                      provider.addSelectedMessage(item.uid);
                                    }
                                  }
                                },
                                onLongPressStart: (details) {
                                  print('length => $length ');

                                  // print('${provider.selectedMessages} ');
                                  if (!isSelected) {
                                    provider.addSelectedMessage(item.uid);
                                  } else {
                                    provider.removeSelectedMessage(item.uid);
                                  }
                                },
                              ),
                            );
                          },
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


// if (provider.selectedMessages.length <= 1) {
                                  //   showDialog<void>(
                                  //     context: context,
                                  //     barrierColor: Colors.black26,
                                  //     builder: (_) {
                                  //       return Stack(
                                  //         children: [
                                  //           Positioned(
                                  //             left: !isCurrentUser ? 50 : null,
                                  //             right: isCurrentUser ? 50 : null,
                                  //             top:
                                  //                 details.globalPosition.dy -
                                  //                 100,
                                  //             child: Material(
                                  //               borderRadius:
                                  //                   BorderRadius.circular(8),
                                  //               color:
                                  //                   context
                                  //                       .color
                                  //                       .surfaceContainer,
                                  //               elevation: 4,
                                  //               child: Row(
                                  //                 mainAxisSize:
                                  //                     MainAxisSize.min,
                                  //                 children: [
                                  //                   IconButton(
                                  //                     icon: const Icon(
                                  //                       Icons.forward,
                                  //                     ),
                                  //                     onPressed: () {
                                  //                       Navigator.pop(context);
                                  //                       // Handle forward
                                  //                     },
                                  //                   ),
                                  //                   IconButton(
                                  //                     icon: const Icon(
                                  //                       Icons.backspace,
                                  //                     ),
                                  //                     onPressed: () {
                                  //                       Navigator.pop(context);
                                  //                       // Handle back
                                  //                     },
                                  //                   ),
                                  //                   IconButton(
                                  //                     icon: const Icon(
                                  //                       Icons.copy,
                                  //                     ),
                                  //                     onPressed: () {
                                  //                       Navigator.pop(context);
                                  //                       // Handle copy
                                  //                     },
                                  //                   ),
                                  //                   IconButton(
                                  //                     icon: const Icon(
                                  //                       Icons.delete,
                                  //                     ),
                                  //                     onPressed: () {
                                  //                       Navigator.pop(context);
                                  //                       // Handle delete
                                  //                     },
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       );
                                  //     },
                                  //   );
                                  // }