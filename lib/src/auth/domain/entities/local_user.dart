import 'package:equatable/equatable.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';

class LocalUser extends Equatable{

  const LocalUser({
    required this.uid,
    required this.phone,
    required this.name,
    this.avatar,
    this.bio,
    this.chats = const [],
    this.activeChatId,
    this.fcmToken,
  });

  const LocalUser.empty() : this(
    phone: '',
    name: '',
    uid: '',
    bio: '',
  );

  final String uid;
  final String name;
  final String phone;
  final String? avatar;
  final String? bio;
  final List<Chat> chats; 
  final String? activeChatId;
  final String? fcmToken;

  @override
  List<Object?> get props => [
    uid, phone, name, avatar, bio, chats, activeChatId, fcmToken,
  ];

  @override
  String toString(){
    return 'LocalUser{id: $uid, phone: $phone, bio: $bio, ' 
    'name: $name, avatar: $avatar, chats: $chats, activeChatUid: $activeChatId, '
    'fcmToken: $fcmToken}';
  }


}
