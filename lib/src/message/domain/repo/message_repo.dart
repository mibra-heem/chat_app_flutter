import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';

abstract class MessageRepo {
 const MessageRepo();
 
 RFuture<void> sendMessage({
  required LocalUser user, 
  required Chat chat,
  required String message,
});
}
