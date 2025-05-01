import 'package:firebase_auth/firebase_auth.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/services/dependency_injection.dart';

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

  static User? getUser(){
    return sl<FirebaseAuth>().currentUser;
  }
}
