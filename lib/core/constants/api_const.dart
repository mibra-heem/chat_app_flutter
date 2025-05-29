import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConst {
  const ApiConst._();

  static const baseUrl = '';

  static const fcmSendUrl =
      'https://fcm.googleapis.com/v1/projects/chat-app-187f5/messages:send';

  static const scopes = [
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/firebase.database',
    'https://www.googleapis.com/auth/firebase.messaging',
  ];
  static final serviceAccountJson = {
    'type': dotenv.env['TYPE'],
    'project_id': dotenv.env['PROJECT_ID'],
    'private_key_id': dotenv.env['PRIVATE_KEY_ID'],
    'private_key': dotenv.env['PRIVATE_KEY']!.replaceAll(r'\n', '\n'),
    'client_email': dotenv.env['CLIENT_EMAIL'],
    'client_id': dotenv.env['CLIENT_ID'],
    'auth_uri': dotenv.env['AUTH_URI'],
    'token_uri': dotenv.env['TOKEN_URI'],
    'auth_provider_x509_cert_url': dotenv.env['AUTH_PROVIDER_X509_CERT_URL'],
    'client_x509_cert_url': dotenv.env['CLIENT_X509_CERT_URL'],
    'universe_domain': dotenv.env['UNIVERSE_DOMAIN'],
  };

}
