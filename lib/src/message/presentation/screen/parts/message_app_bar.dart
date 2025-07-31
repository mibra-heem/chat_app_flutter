import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/app/widgets/arrow_back_button.dart';
import 'package:mustye/core/config/route_config.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/core/utils/core_utils.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/message/features/call/audio/data/models/incoming_audio_call_model.dart';
import 'package:mustye/src/message/features/call/audio/presentation/provider/audio_call_provider.dart';
import 'package:mustye/src/message/presentation/provider/message_provider.dart';
import 'package:provider/provider.dart';

class MessageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MessageAppBar({required this.chat, super.key});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Consumer<MessageProvider>(
      builder: (context, provider, _) {
        return AppBar(
          title: Text(
            provider.selectedMessages.isEmpty ? chat.name : 'Delete Messages',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          leading: const ArrowBackButton(),
          titleSpacing: 0,
          actions:
              provider.selectedMessages.isEmpty
                  ? [
                    IconButton(
                      onPressed: () {
                        debugPrint('Click on videoCall');
                        context.pushNamed(RouteName.videoCall, extra: chat);
                      },
                      icon: const Icon(IconlyBold.video, size: 26),
                    ),
                    IconButton(
                      onPressed: () {
                        debugPrint('Click on audioCall');
                        final user = context.currentUser!;
                        final docId = CoreUtils.joinIdsWithTimeStamp(
                          userId: user.uid,
                          chatId: chat.uid,
                        );
                        final call = AudioCallModel(
                          uid: docId,
                          callerId: user.uid,
                          receiverId: chat.uid,
                          callerName: user.name,
                          receiverName: chat.name,
                          callerEmail: user.email,
                          receiverEmail: chat.email,
                          callerImage: user.image,
                          receiverImage: chat.image,
                          isCallOn: true,
                          createdAt: Timestamp.now().toDate(),
                        );
                        sl<AudioCallProvider>().activateIncomingAudioCall(call);
                        context.pushNamed(RouteName.audioCall, extra: call);
                      },
                      icon: const Icon(IconlyBold.call),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert_rounded),
                    ),
                  ]
                  : [
                    IconButton(
                      onPressed: () {
                        provider
                          ..deleteMessages(
                            messages: provider.getSelectedMessages,
                            chatId: chat.uid,
                          )
                          ..clearSelectedMessages();
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
