import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mustye/core/common/views/loading_view.dart';
import 'package:mustye/core/common/widgets/message_tile.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';
import 'package:mustye/src/message/domain/entity/message.dart';
import 'package:mustye/src/message/presentation/parts/message_foot.dart';
import 'package:mustye/src/message/presentation/utils/message_utils.dart';

class MessageBody extends StatefulWidget {
  const MessageBody({
    required this.contact,
    super.key,
  });

  final Contact contact;

  @override
  State<MessageBody> createState() => _MessageBodyState();
}

class _MessageBodyState extends State<MessageBody> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<List<Message>>(
          stream: MessageUtils.getMessages(widget.contact.uid),
          builder: (context, snapshot) {
            if(kDebugMode) print('....... Messsages Streaming .......');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingView();
            }else if (snapshot.hasError) {
              if(kDebugMode) print('Error: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            }else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No messages yet.'));
            }

            final messages = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 75),
              child: CustomScrollView(
                shrinkWrap: true,
                reverse: true, // To start from the bottom
                slivers: [
                  SliverList(
                    
                    delegate: SliverChildBuilderDelegate(
                      
                      (context, index) {
                        final message = messages[index];
                        final isCurrentUser = 
                          context.currentUser!.uid == message.senderId;
                        return MessageTile(
                          message: message.msg,
                          isCurrentUser: isCurrentUser,
                        );
                      },
                      childCount: messages.length,
                    ),
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
          child: MessageFoot(contact: widget.contact),
        ),
      ],
    );
  }
}
