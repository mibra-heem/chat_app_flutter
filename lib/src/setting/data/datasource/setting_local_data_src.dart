import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:mustye/core/constants/storage_const.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/utils/datasource_utils.dart';

abstract class SettingLocalDataSrc {
  const SettingLocalDataSrc();

  Future<bool> checkIfDarkModeOn();
  Future<void> cacheDarkMode({required bool isDarkMode});
}

class SettingLocalDataSrcImpl implements SettingLocalDataSrc {
  const SettingLocalDataSrcImpl({required Box<dynamic> settingBox})
    : _settingBox = settingBox;

  final Box<dynamic> _settingBox;

  @override
  Future<void> cacheDarkMode({required bool isDarkMode}) async {
    try {
      final uid = DatasourceUtils.getUser()!.uid;
      await _settingBox.put(StorageConstant.darkMode + uid, isDarkMode);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw CacheException(
        message: e.toString(),
        statusCode: 'cache-dark-Mode-failed',
      );
    }
  }

  @override
  Future<bool> checkIfDarkModeOn() async {
    try {

      final user = DatasourceUtils.getUser();
      if (user == null) {
        return false;
      }

      if (_settingBox.containsKey(StorageConstant.darkMode + user.uid)) {
        return _settingBox.get(StorageConstant.darkMode + user.uid) as bool;
      }
      return false;

    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw CacheException(
        message: e.toString(),
        statusCode: 'check-if-dark-Mode-on-failed',
      );
    }
  }
}
