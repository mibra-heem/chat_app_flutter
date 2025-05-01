import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';

abstract class ChatRepo {
  const ChatRepo();
  RFuture<void> deleteChat(Chat chat);
  RFuture<void> messageSeen({
    required String chatUid
  });

}
