import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:mustye/core/utils/constants.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/message/domain/usecases/activate_chat.dart';
import 'package:mustye/src/message/domain/usecases/send_message.dart';

class MessageProvider extends ChangeNotifier {
  MessageProvider({
    required SendMessage sendMessage,
    required ActivateChat activateChat,
  }) : _sendMessage = sendMessage,
       _activateChat = activateChat;

  final SendMessage _sendMessage;
  final ActivateChat _activateChat;

  Future<void> sendMessage({
    required LocalUser sender,
    required Chat reciever,
    required String message,
  }) async {
    final result = await _sendMessage(
      SendMessageParams(sender: sender, reciever: reciever, message: message),
    );

    result.fold(
      (failure) => failure.errorMessage,
      (_) => 'Message sended successfully.',
    );
  }

  Future<void> setActiveChatId({required String? activeChatId}) async {
    final result = await _activateChat(activeChatId);

    result.fold((f) => debugPrint(f.errorMessage), (_) => null);
  }
}
