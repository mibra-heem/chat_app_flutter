import 'package:mustye/core/errors/exception.dart';

class DatasourceUtils {
  DatasourceUtils._();

  static Future<void> authorizeUser(auth) async {
    final user = auth.currentUser;
    if (user == null) {
      throw const ServerException(
        message: 'User is not authenticated.',
        statusCode: '401',
      );
    }
  }
}
