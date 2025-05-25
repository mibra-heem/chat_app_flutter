import 'package:flutter/foundation.dart';
import 'package:mustye/src/auth/data/models/local_user_model.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/auth/domain/usecases/cache_user_data.dart';
import 'package:mustye/src/auth/domain/usecases/get_user_cached_data.dart';

class UserProvider extends ChangeNotifier {
  UserProvider({
    required CacheUserData cacheUserData,
    required GetUserCachedData getUserCachedData,
  }) : _cacheUserData = cacheUserData,
       _getUserCachedData = getUserCachedData;

  final CacheUserData _cacheUserData;
  final GetUserCachedData _getUserCachedData;

  LocalUserModel? _user;

  LocalUserModel? get user => _user;

  bool _isUserLoading = false;

  bool get isUserLoading => _isUserLoading;

  set isUserLoading(bool loading){
    _isUserLoading = loading;
    notifyListeners();
  }

  void initUser(LocalUserModel? user) {
    if (_user != user) _user = user;
  }

  set user(LocalUserModel? user) {
    if (_user != user) {
      _user = user;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  Future<void> getUserCachedData() async {

    isUserLoading = true;

    final result = await _getUserCachedData();

    result.fold(
      (failure) {
        if (kDebugMode) print(failure.errorMessage);
      },
      (u) {
        initUser(u as LocalUserModel?);
      },
    );
    isUserLoading = false;
  }

  Future<void> cacheUserData(LocalUser u) async {
    user = u as LocalUserModel;

    final result = await _cacheUserData(u);

    result.fold((failure) {
      if (kDebugMode) print(failure.errorMessage);
    }, (_) {
    },);
  }
}
