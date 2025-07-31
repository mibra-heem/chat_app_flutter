import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';

abstract class ChatRepo {
  const ChatRepo();
  RFuture<void> deleteChat(List<Chat> chat);
  RFuture<void> messageSeen({
    required String senderUid,
  });
  
}
