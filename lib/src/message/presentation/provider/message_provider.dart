import 'package:flutter/foundation.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/message/domain/entity/message.dart';
import 'package:mustye/src/message/domain/usecases/activate_chat.dart';
import 'package:mustye/src/message/domain/usecases/detele_messages.dart';
import 'package:mustye/src/message/domain/usecases/send_message.dart';

class MessageProvider extends ChangeNotifier {
  MessageProvider({
    required SendMessage sendMessage,
    required ActivateChat activateChat,
    required DeleteMessages deleteMessages,
  }) : _sendMessage = sendMessage,
       _activateChat = activateChat,
       _deleteMessages = deleteMessages;

  final SendMessage _sendMessage;
  final ActivateChat _activateChat;
  final DeleteMessages _deleteMessages;

  List<Message> messages = [];
  // List<Message> get messages => _messages;

  final List<String> _selectedMessages = [];
  List<String> get selectedMessages => _selectedMessages;

  void addSelectedMessage(String? uid) {
    final id = uid ?? '';
    _selectedMessages.add(id);
    notifyListeners();
  }

  void removeSelectedMessage(String? uid) {
    final id = uid ?? '';
    _selectedMessages.remove(id);
    notifyListeners();
  }

  void clearSelectedMessages() {
    _selectedMessages.clear();
    notifyListeners();
  }

  List<Message> get getSelectedMessages {
    return messages
        .where((message) => selectedMessages.contains(message.uid))
        .toList();
  }

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

  Future<void> deleteMessages({
    required List<Message> messages,
    required String chatId,
  }) async {
    final result = await _deleteMessages(
      DeleteMessagesParams(messages: messages, chatId: chatId),
    );

    result.fold((f) => debugPrint(f.errorMessage), (_) => null);
  }
}
