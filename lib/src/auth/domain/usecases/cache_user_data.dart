import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/auth/domain/repos/auth_repo.dart';

class CacheUserData extends UseCaseWithParams<void, LocalUser>{
  CacheUserData(this._repo);

  final AuthRepo _repo;
  @override
  RFuture<void> call(LocalUser user) => _repo.cacheUserData(user);
}
