import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';
import 'package:mustye/src/contact/domain/repo/contact_repo.dart';

class AddContact extends UseCaseWithParams<void, Contact>{

  AddContact(this._repo);

  final ContactRepo _repo;
  
  @override
  RFuture<void> call(Contact contact) => _repo.addContact(contact);
  
}
