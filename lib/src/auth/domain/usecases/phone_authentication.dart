import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/repos/auth_repo.dart';

class PhoneAuthentication extends UseCaseWithParams<String,String>{

  PhoneAuthentication(this._repo);

  final AuthRepo _repo;
  
  @override
  RFuture<String> call(String phone) => _repo.phoneAuthentication(phone);
  
}
