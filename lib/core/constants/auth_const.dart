import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthConstant {
  const AuthConstant._();
  static final googleWebOAuthClientId =
      dotenv.env['GOOGLE_WEB_OAUTH_CLIENT_ID'] ?? '';

  static const List<String> scopes = ['openid', 'email', 'profile'];
}
