import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/setting/domain/repo/setting_repo.dart';

class CacheDarkMode extends UseCaseWithParams<void, bool>{

  const CacheDarkMode(this._repo);

  final SettingRepo _repo;

  @override
  RFuture<void> call(bool isDarkMode) => _repo.cacheDarkMode(
    isDarkMode: isDarkMode,
  );
}
