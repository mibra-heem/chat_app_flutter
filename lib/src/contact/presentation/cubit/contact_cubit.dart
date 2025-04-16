import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';
import 'package:mustye/src/contact/domain/usecase/add_contact.dart';
import 'package:mustye/src/contact/domain/usecase/get_contacts.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit({
    required GetContacts getContacts,
    required AddContact addContact,
  }) : 
    _getContacts = getContacts,
    _addContact = addContact,

  super(ContactInitial());

  final GetContacts _getContacts;
  final AddContact _addContact;

  Future<void> getContacts()async{
    emit(const LoadingContacts());
    final result = await _getContacts();

    result.fold(
      (failure) => emit(ContactError(failure.errorMessage)),
      (contacts) => emit(ContactsLoaded(contacts)),
    );
  }

  Future<void> addContact(Contact contact) async{
    emit(const AddingContact());
    final result = await _addContact(contact);

    result.fold(
      (failure) => emit(ContactError(failure.errorMessage)),
      (_) => emit(const ContactAdded()),
    );
  }
}
