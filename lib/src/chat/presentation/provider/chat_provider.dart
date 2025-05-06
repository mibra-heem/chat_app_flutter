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
    required String senderUid,
  }) async{
    final result = await _messageSeen(
      MessageSeenParams(
        senderUid: senderUid, 
      ),
    );

    result.fold(
      (f) => debugPrint(f.errorMessage), 
      (_) => null,
    );
  }

}
