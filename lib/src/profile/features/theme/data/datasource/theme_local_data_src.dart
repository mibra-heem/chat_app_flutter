import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mustye/core/constants/storage_const.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/utils/datasource_utils.dart';

abstract class ThemeLocalDataSrc {
  const ThemeLocalDataSrc();

  Future<int> loadThemeMode();
  Future<void> cacheThemeMode(int index);
}

class ThemeLocalDataSrcImpl implements ThemeLocalDataSrc {
  const ThemeLocalDataSrcImpl({required Box<dynamic> themeBox})
    : _themeBox = themeBox;

  final Box<dynamic> _themeBox;

  @override
  Future<void> cacheThemeMode(int index) async {
    try {
      final uid = DatasourceUtils.getUser()!.uid;
      await _themeBox.put(StorageConstant.theme + uid, index);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw CacheException(
        message: e.toString(),
        statusCode: 'cache-theme-mode-failed',
      );
    }
  }

  @override
  Future<int> loadThemeMode() async {
    try {
      final user = DatasourceUtils.getUser();
      if (user == null) {
        return ThemeMode.system.index;
      }

      if (_themeBox.containsKey(StorageConstant.theme + user.uid)) {
        final index = _themeBox.get(StorageConstant.theme + user.uid) as int;
        return index;
      }
      return ThemeMode.system.index;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw CacheException(
        message: e.toString(),
        statusCode: 'load-theme-mode-failed',
      );
    }
  }
}
