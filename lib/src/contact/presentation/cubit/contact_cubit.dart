import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/contact/domain/usecase/get_contacts.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit({
    required GetContacts getContacts,
  }) : 
    _getContacts = getContacts,

  super(ContactInitial());

  final GetContacts _getContacts;

  Future<void> getContacts()async{
    emit(const LoadingContacts());
    final result = await _getContacts();

    result.fold(
      (failure) => emit(ContactError(failure.errorMessage)),
      (contacts) => emit(ContactsLoaded(contacts)),
    );

  }
}
