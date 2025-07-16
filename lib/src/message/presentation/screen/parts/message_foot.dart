import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/app/widgets/gradient_background.dart';
import 'package:mustye/core/app/widgets/my_field.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/resources/colors.dart';
import 'package:mustye/src/auth/data/models/local_user_model.dart';
import 'package:mustye/src/chat/data/model/chat_model.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/message/presentation/provider/message_provider.dart';
import 'package:mustye/src/profile/features/theme/presentation/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class MessageFoot extends StatelessWidget {
  MessageFoot({required this.chat, super.key});

  final Chat chat;
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser!;
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GradientBackground(
        child: Row(
          spacing: 5,
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: MyField(
                  controller: messageController,
                  hintText: 'message',
                  prefixIcon: const Icon(IconlyBold.image),
                  suffixIcon: const Icon(Icons.attach_file),
                  maxLines: 100,
                  isTextArea: true,
                  isFocusOnTapOutside: false,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (messageController.text.isNotEmpty) {
                  context.read<MessageProvider>().sendMessage(
                    sender: LocalUserModel(
                      uid: user.uid,
                      email: user.email,
                      name: user.name,
                      image: user.image,
                      bio: user.bio,
                      activeChatId: user.activeChatId,
                    ),
                    reciever: ChatModel(
                      uid: chat.uid,
                      email: chat.email,
                      name: chat.name,
                      image: chat.image,
                      bio: chat.bio,
                    ),
                    message: messageController.text.trim(),
                  );
                  messageController.text = '';
                }
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color:
                      context.read<ThemeProvider>().themeMode ==
                              ThemeMode.dark
                          ? Colours.white
                          : Colours.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  IconlyBold.send,
                  color:
                      context.read<ThemeProvider>().themeMode ==
                              ThemeMode.dark
                          ? Colours.primary
                          : Colours.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
