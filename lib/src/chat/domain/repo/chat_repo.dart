import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';

abstract class ChatRepo {
  const ChatRepo();
  RFuture<List<Contact>> getChats();
}
