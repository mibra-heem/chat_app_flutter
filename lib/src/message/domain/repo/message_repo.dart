import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';

abstract class MessageRepo {
 const MessageRepo();
 
 RFuture<void> sendMessage({
  required LocalUser user, 
  required Contact contact,
  required String message,
});
}
