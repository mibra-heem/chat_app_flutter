import 'package:equatable/equatable.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';

class LocalUser extends Equatable{

  const LocalUser({
    required this.uid,
    required this.email,
    required this.name,
    this.image,
    this.bio,
    this.chats = const [],
    this.activeChatId,
    this.fcmToken,
  });

  const LocalUser.empty() : this(
    email: '',
    name: '',
    uid: '',
    image: '',
    bio: '',
  );

  final String uid;
  final String name;
  final String email;
  final String? image;
  final String? bio;
  final List<Chat> chats; 
  final String? activeChatId;
  final String? fcmToken;

  @override
  List<Object?> get props => [
    uid, email, name, image, bio, chats, activeChatId, fcmToken,
  ];

  @override
  String toString(){
    return 'LocalUser{id: $uid, email: $email, bio: $bio, ' 
    'name: $name, image: $image, chats: $chats, activeChatUid: $activeChatId, '
    'fcmToken: $fcmToken}';
  }


}
