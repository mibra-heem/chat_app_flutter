import 'package:mustye/core/usecases/usecases.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/profile/features/theme/domain/repo/theme_repo.dart';

class LoadThemeMode extends UseCaseWithoutParams<int>{

  const LoadThemeMode(this._repo);

  final ThemeRepo _repo;

  @override
  RFuture<int> call() => _repo.loadThemeMode();
}
