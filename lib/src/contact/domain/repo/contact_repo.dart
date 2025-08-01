import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/contact/domain/entities/local_contact.dart';
import 'package:mustye/src/contact/domain/entities/remote_contact.dart';

abstract class ContactRepo {
  const ContactRepo();
  RFuture<List<RemoteContact>> getContacts();
  RFuture<void> addContact(LocalContact contact);
}
