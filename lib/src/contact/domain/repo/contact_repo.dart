import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';

abstract class ContactRepo {
  const ContactRepo();
  RFuture<List<LocalUser>> getContacts();
}
