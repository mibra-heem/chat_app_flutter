import 'package:firebase_auth/firebase_auth.dart';
import 'package:mustye/core/errors/exception.dart';

class DatasourceUtils {
  DatasourceUtils._();

  static Future<void> authorizeUser(FirebaseAuth auth) async {
    final user = auth.currentUser;
    if (user == null) {
      throw const ServerException(
        message: 'User is not authenticated.',
        statusCode: '401',
      );
    }
  }

  static String joinIds({required String userId, required String chatId}) {
    final ids = [userId, chatId]..sort();
    return ids.join('_');
  }
}
