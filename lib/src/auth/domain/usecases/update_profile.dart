import 'package:equatable/equatable.dart';
import 'package:mustye/core/enums/update_user_action.dart';
import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/repos/auth_repo.dart';

class UpdateUser extends UseCaseWithParams<void, UpdateUserParams>{

  UpdateUser(this._repo);

  final AuthRepo _repo;
  @override
  RFuture<void> call(UpdateUserParams params) => _repo.updateUser(
    action: params.action,
    userData: params.userData,
  );
}

class UpdateUserParams extends Equatable{

  const UpdateUserParams({
    required this.action,
    required this.userData,
  });

  const UpdateUserParams.empty(): this(
    action: UpdateUserAction.displayName,
    userData: '',
  );

  final UpdateUserAction action;
  final dynamic userData;

  @override
  List<Object?> get props => [action, userData];

}
