import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mustye/core/config/storage_config.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/services/dependency_injection.dart';

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
      final uid = sl<FirebaseAuth>().currentUser!.uid;
      await _themeBox.put(StorageConfig.theme + uid, index);
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
      final user = sl<FirebaseAuth>().currentUser;
      if (user == null) {
        return ThemeMode.system.index;
      }

      if (_themeBox.containsKey(StorageConfig.theme + user.uid)) {
        final index = _themeBox.get(StorageConfig.theme + user.uid) as int;
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
