import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';
import 'package:mustye/src/contact/domain/repo/contact_repo.dart';

class GetContacts extends UseCaseWithoutParams<List<Contact>>{

  GetContacts(this._repo);

  final ContactRepo _repo;
  
  @override
  RFuture<List<Contact>> call() => _repo.getContacts();
  
}
