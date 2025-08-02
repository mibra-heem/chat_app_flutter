import 'package:flutter/foundation.dart';
import 'package:mustye/core/extensions/string_extention.dart';
import 'package:mustye/src/contact/domain/entities/local_contact.dart';
import 'package:mustye/src/contact/domain/entities/remote_contact.dart';

import 'package:mustye/src/contact/domain/usecase/add_contact.dart';
import 'package:mustye/src/contact/domain/usecase/get_contacts.dart';

class ContactProvider extends ChangeNotifier {
  ContactProvider({
    required AddContact addContact,
    required GetContacts getContacts,
  }) : _addContact = addContact,
       _getContacts = getContacts;

  final AddContact _addContact;
  final GetContacts _getContacts;

  List<RemoteContact> _contacts = [];
  List<RemoteContact> get contacts => _contacts;

  Future<void> getContacts() async {
    final result = await _getContacts();

    result.fold((failure) => failure.errorMessage, (contacts) {
      debugPrint('Registered Contacts => $contacts');
      _contacts = contacts;
      notifyListeners();
    });
  }

  Future<void> addContact(LocalContact contact) async {
    final result = await _addContact(contact);

    result.fold(
      (failure) => failure.errorMessage,
      (_) => 'Successfully added the contact in users list.',
    );
  }

  RemoteContact findRegisteredUserByPhone(String phone) {
    return _contacts.firstWhere((contact) {
      debugPrint(
        'Check Remote Contact Normalized Version ${contact.phone.normalizePhone()}',
      );
      debugPrint(
        'Check Local Contact Normalized Version ${phone.normalizePhone()}',
      );

      return contact.phone.normalizePhone() == phone.normalizePhone();
    }, orElse: () => const RemoteContact.empty());
  }
}
