import 'package:equatable/equatable.dart';
import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/repositories/auth_repo.dart';

class ForgotPassword extends UseCaseWithParams<void, ForgotPasswordParams>{

  ForgotPassword(this._repo);

  final AuthRepo _repo;
  @override
  RFuture<void> call(ForgotPasswordParams params) => _repo.forgotPassword(
    params.email,
  );
  
}

class ForgotPasswordParams extends Equatable{

  const ForgotPasswordParams({
    required this.email,
  });

  final String email;

  @override
  List<Object?> get props => [email];

}
