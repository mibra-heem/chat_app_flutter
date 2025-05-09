import 'package:flutter_dotenv/flutter_dotenv.dart';

const kDefaultAvatar =
    'https://images.freeimages.com/fic/images/icons/573/must_have/256/user.png';

class StorageConstant {
  const StorageConstant._();
  static const String userBox = 'user_box';
  static const String darkMode = 'dark_mode_';
  static const String messageBox = 'message_box';
  static const String settingBox = 'setting_box';
  static const String chatBox = 'chat_box';
}

class AuthConstant {
  const AuthConstant._();
  static String clientId = dotenv.env['GOOGLE_WEB_OAUTH_CLIENT_ID'] ?? '';

  static const List<String> scopes = ['openid', 'email', 'profile'];

}

class GetItConstant {

  const GetItConstant._();
  static const String chatView = 'chat_view';
  static const String profileView = 'profile_view';

}
