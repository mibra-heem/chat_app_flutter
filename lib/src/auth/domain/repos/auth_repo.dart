import 'package:mustye/core/enums/update_user_action.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';

abstract class AuthRepo {
  const AuthRepo();
  
  RFuture<String> phoneAuthentication(String phone);
  RFuture<void> verifyOTP(String otp);
  RFuture<void> updateUser({
    required UpdateUserAction action,
    dynamic userData,
  });
  RFuture<void> cacheUserData(LocalUser user);
  RFuture<LocalUser> getUserCachedData();
}
