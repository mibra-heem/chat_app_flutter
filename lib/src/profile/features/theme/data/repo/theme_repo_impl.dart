import 'package:dartz/dartz.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/errors/failure.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/profile/features/theme/data/datasource/theme_local_data_src.dart';
import 'package:mustye/src/profile/features/theme/domain/repo/theme_repo.dart';


class ThemeRepoImpl implements ThemeRepo {
  const ThemeRepoImpl(this._localDataSrc);

  final ThemeLocalDataSrc _localDataSrc;

  @override
  RFuture<void> cacheThemeMode(int index) async {
    try {
      await _localDataSrc.cacheThemeMode(index);

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  RFuture<int> loadThemeMode() async {
    try {
      final result = await _localDataSrc.loadThemeMode();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
