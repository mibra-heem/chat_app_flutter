import 'package:flutter/material.dart';
import 'package:mustye/src/chat/domain/usecases/delete_chat.dart';
import 'package:mustye/src/chat/domain/usecases/message_seen.dart';

class ChatProvider extends ChangeNotifier{
  ChatProvider({
    required MessageSeen messageSeen,
    required DeleteChat deleteChat,
  }) : _messageSeen = messageSeen,
  _deleteChat = deleteChat;

  final DeleteChat _deleteChat;
  final MessageSeen _messageSeen;

  Future<void> messageSeen({
    required String chatUid,
  }) async{
    final result = await _messageSeen(
      MessageSeenParams(
        chatUid: chatUid, 
      ),
    );

    result.fold(
      (f) => debugPrint(f.errorMessage), 
      (_) => null,
    );
  }

}
