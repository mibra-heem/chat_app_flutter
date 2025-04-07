import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/contact/domain/repo/contact_repo.dart';

class GetContacts extends UseCaseWithoutParams<List<LocalUser>>{

  GetContacts(this._repo);

  final ContactRepo _repo;
  
  @override
  RFuture<List<LocalUser>> call() => _repo.getContacts();
  
}
