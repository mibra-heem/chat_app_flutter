import 'package:firebase_auth/firebase_auth.dart';
import 'package:mustye/core/errors/exception.dart';

class DatasourceUtils {
  DatasourceUtils._();

  static void authorizeUser(FirebaseAuth auth) {
    final user = auth.currentUser;
    if (user == null) {
      throw const UserNotFoundException(
        message: 'User is not authenticated.',
      );
    }
  }

  static String joinIds({required String userId, required String chatId}) {
    final ids = [userId, chatId]..sort();
    return ids.join('_');
  }
}
