import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/profile/features/theme/domain/repo/theme_repo.dart';

class CacheThemeMode extends UseCaseWithParams<void, int>{

  const CacheThemeMode(this._repo);

  final ThemeRepo _repo;

  @override
  RFuture<void> call(int index) => _repo.cacheThemeMode(index);
}
