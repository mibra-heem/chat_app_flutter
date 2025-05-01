import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';

abstract class ContactRepo {
  const ContactRepo();
  RFuture<List<Contact>> getContacts();
  RFuture<void> addContact(Contact contact);
}
