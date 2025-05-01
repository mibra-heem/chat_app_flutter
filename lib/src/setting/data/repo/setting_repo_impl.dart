import 'package:dartz/dartz.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/errors/failure.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/setting/data/datasource/setting_local_data_src.dart';
import 'package:mustye/src/setting/domain/repo/setting_repo.dart';

class SettingRepoImpl implements SettingRepo {
  const SettingRepoImpl(this._localDataSrc);

  final SettingLocalDataSrc _localDataSrc;

  @override
  RFuture<void> cacheDarkMode({required bool isDarkMode}) async {
    try {
      await _localDataSrc.cacheDarkMode(isDarkMode: isDarkMode);

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  RFuture<bool> checkIfDarkModeOn() async {
    try {
      final result = await _localDataSrc.checkIfDarkModeOn();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
