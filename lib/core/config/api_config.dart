import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  const ApiConfig._();

  static final baseUrl = dotenv.env['BASE_URL'] ?? 'http://192.168.18.86:8000';
  // static const baseUrl = 'http://192.168.18.86:8000';

  static const generateAgoraTokenUrl = '/api/agora/token';

  static const fcmSendUrl =
      'https://fcm.googleapis.com/v1/projects/chat-app-187f5/messages:send';

  static const scopes = [
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/firebase.database',
    'https://www.googleapis.com/auth/firebase.messaging',
  ];
  static const fcmToken = 'fcmToken';
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
