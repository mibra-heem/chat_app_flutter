import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/auth/domain/repos/auth_repo.dart';

class GoogleLoginIn extends UseCaseWithoutParams<LocalUser>{

  GoogleLoginIn(this._repo);

  final AuthRepo _repo;
  
  @override
  RFuture<LocalUser> call() => _repo.googleSignIn();
  
}
