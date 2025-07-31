
import 'package:flutter_dotenv/flutter_dotenv.dart';

const kDefaultAvatar =
    'https://images.freeimages.com/fic/images/icons/573/must_have/256/user.png';

const appName = 'Mustye';

final agoraAppId = dotenv.env['AGORA_APP_ID'] ?? '';
