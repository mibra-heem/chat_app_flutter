import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';

abstract class MessageRepo {
  const MessageRepo();

  RFuture<void> sendMessage({
    required LocalUser sender,
    required Chat reciever,
    required String message,
  });

  RFuture<void> setActiveChatId({required String? activeChatId});
}
