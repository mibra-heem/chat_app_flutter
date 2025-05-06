import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  const Chat({
    required this.uid,
    required this.email,
    required this.name,
    this.image,
    this.bio,
    this.lastMsg,
    this.lastMsgTime,
    this.unSeenMsgCount = 0,
    this.isMsgSeen = true,
    this.lastSeen,
    this.isOnline = false,
    this.fcmToken,
  });

  const Chat.empty() : this(uid: '', email: '', name: '', image: '');

  final String uid;
  final String email;
  final String? image;
  final String? bio;
  final String name;
  final String? lastMsg;
  final DateTime? lastMsgTime;
  final int unSeenMsgCount;
  final bool isMsgSeen;
  final String? lastSeen;
  final bool isOnline;
  final String? fcmToken;

  @override
  List<Object?> get props => [
    uid,
    email,
    name,
    image,
    bio,
    lastMsg,
    unSeenMsgCount,
    lastMsgTime,
    isMsgSeen,
    lastSeen,
    isOnline,
  ];

  @override
  String toString() {
    return 'Chat{uid: $uid, email: $email, name: $name, bio: $bio, '
        'lastMsg: $lastMsg, lastMsgTime: $lastMsgTime, '
        'isMsgSeen: $isMsgSeen, unSeenMsgCount: $unSeenMsgCount }';
  }
}
