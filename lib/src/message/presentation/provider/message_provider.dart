import 'package:flutter/foundation.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';
import 'package:mustye/src/message/domain/usecases/send_message.dart';

class MessageProvider extends ChangeNotifier{

  MessageProvider({
    required SendMessage sendMessage, 
  }) : _sendMessage = sendMessage;

  final SendMessage _sendMessage;

  Future<void> sendMessage({
    required LocalUser user, 
    required Contact contact,
    required String message,
  }) async{
    final result = await _sendMessage(
      SendMessageParams(
        user: user, 
        contact: contact,
        message: message
      ),
    );

    result.fold(
      (failure) => failure.errorMessage,
      (_){
        if(kDebugMode) print('..... Message sended successfully ......');
        return '..... Message sended successfully ......';
      }
    );
  }
}
