import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/contact/domain/entities/remote_contact.dart';
import 'package:mustye/src/contact/domain/repo/contact_repo.dart';

class GetContacts extends UseCaseWithoutParams<List<RemoteContact>>{

  GetContacts(this._repo);

  final ContactRepo _repo;
  
  @override
  RFuture<List<RemoteContact>> call() => _repo.getContacts();
  
}
