part of 'contact_cubit.dart';

sealed class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object> get props => [];
}

final class ContactInitial extends ContactState {}

class LoadingContacts extends ContactState{
  const LoadingContacts();
}

class ContactsLoaded extends ContactState{
  const ContactsLoaded(this.contacts);

  final List<LocalUser> contacts;

  @override
  List<Object> get props => [contacts];

}

class ContactError extends ContactState{
  const ContactError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
