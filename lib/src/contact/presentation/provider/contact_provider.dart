import 'package:flutter/foundation.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';
import 'package:mustye/src/contact/domain/usecase/add_contact.dart';

class ContactProvider extends ChangeNotifier{

  ContactProvider({
    required AddContact addContact, 
  }) : _addContact = addContact;

  final AddContact _addContact;

  Future<void> addContact(Contact contact) async{
    final result = await _addContact(contact);

    result.fold(
      (failure) => failure.errorMessage,
      (_){
        if(kDebugMode) print('Successfully added the contact in users list.');
        return 'Successfully added the contact in users list.';
      }
    );
  }
}
