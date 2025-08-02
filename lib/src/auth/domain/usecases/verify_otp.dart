import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/repos/auth_repo.dart';

class VerifyOTP extends UseCaseWithParams<void,String>{

  VerifyOTP(this._repo);

  final AuthRepo _repo;
  
  @override
  RFuture<void> call(String otp) => _repo.verifyOTP(otp);
  
}
