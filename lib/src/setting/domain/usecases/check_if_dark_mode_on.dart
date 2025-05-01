import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/setting/domain/repo/setting_repo.dart';

class CheckIfDarkModeOn extends UseCaseWithoutParams<bool>{

  const CheckIfDarkModeOn(this._repo);

  final SettingRepo _repo;

  @override
  RFuture<bool> call() => _repo.checkIfDarkModeOn();
}
