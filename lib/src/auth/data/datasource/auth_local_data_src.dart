import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:mustye/core/config/storage_config.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/data/models/local_user_model.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';

abstract class AuthLocalDataSource {
  const AuthLocalDataSource();

  Future<void> cacheUserData(LocalUser user);
  Future<LocalUser> getUserCachedData();
}

class AuthLocalDataSrcImpl implements AuthLocalDataSource {
  const AuthLocalDataSrcImpl({required Box<dynamic> userBox})
    : _userBox = userBox;

  final Box<dynamic> _userBox;

  @override
  Future<void> cacheUserData(LocalUser user) async {
    try {
      await _userBox.put(
        StorageConfig.user+user.uid,
        (user as LocalUserModel).toMapLocal(),
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw CacheException(
        message: e.toString(),
        statusCode: 'cache-user-failed',
      );
    }
  }

  @override
  Future<LocalUser> getUserCachedData() async {
    try {
      final currentUser = sl<FirebaseAuth>().currentUser!;
      final userMap = _userBox.get(StorageConfig.user+currentUser.uid);
      final user = SDMap.from(userMap as Map);
      return LocalUserModel.fromMap(user);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw CacheException(
        message: e.toString(),
        statusCode: 'get-user-cache-failed',
      );
    }
  }
}
