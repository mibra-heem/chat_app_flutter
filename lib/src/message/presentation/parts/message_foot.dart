import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/common/widgets/gradient_background.dart';
import 'package:mustye/core/common/widgets/my_field.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/res/colors.dart';
import 'package:mustye/src/auth/data/models/local_user_model.dart';
import 'package:mustye/src/contact/data/model/contact_model.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';
import 'package:mustye/src/message/presentation/provider/message_provider.dart';
import 'package:provider/provider.dart';

class MessageFoot extends StatelessWidget {
  MessageFoot({required this.contact, super.key});

  final Contact contact;
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser!;
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      // decoration: const BoxDecoration(color: Colours.primaryColor),
      child: GradientBackground(
        child: Row(
          spacing: 5,
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: MyField(
                  controller: messageController,
                  filled: true,
                  fillColor: Colors.white,
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
                    user: LocalUserModel(
                      uid: user.uid,
                      email: user.email,
                      fullName: user.fullName,
                      image: user.image,
                      bio: user.bio,
                    ),
                    contact: ContactModel(
                      uid: contact.uid,
                      email: contact.email,
                      fullName: contact.fullName,
                      image: contact.image,
                      bio: contact.bio,
                    ),
                    message: messageController.text.trim(),
                  );
                  messageController.text = '';
                }
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(IconlyBold.send, color: Colours.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
