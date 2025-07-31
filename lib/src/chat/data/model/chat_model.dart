import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.uid,
    required super.email,
    required super.name,
    super.image,
    super.bio,
    super.lastMsg,
    super.lastMsgTime,
    super.unSeenMsgCount,
    super.isMsgSeen,
    super.lastSeen,
    super.isOnline = false,
  });

  const ChatModel.empty() : super.empty();

  ChatModel.fromMap(SDMap map)
    : super(
        uid: map['uid'] as String,
        email: map['email'] as String,
        name: map['name'] as String,
        image: map['image'] as String?,
        bio: map['bio'] as String?,
        lastMsg: map['lastMsg'] as String?,
        lastMsgTime: _parseDateTime(map['lastMsgTime']),
        unSeenMsgCount: map['unSeenMsgCount'] as int,
        isMsgSeen: map['isMsgSeen'] as bool,
        lastSeen: map['lastSeen'] as String?,
        isOnline: map['isOnline'] as bool,
      );

  ChatModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? image,
    String? bio,
    String? lastMsg,
    DateTime? lastMsgTime,
    int? unSeenMsgCount,
    bool? isMsgSeen,
    String? lastSeen,
    bool? isOnline,
  }) {
    return ChatModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      image: image ?? this.image,
      bio: bio ?? this.bio,
      lastMsg: lastMsg ?? this.lastMsg,
      lastMsgTime: lastMsgTime ?? this.lastMsgTime,
      unSeenMsgCount: unSeenMsgCount ?? this.unSeenMsgCount,
      isMsgSeen: isMsgSeen ?? this.isMsgSeen,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  SDMap toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'image': image,
      'bio': bio,
      'lastMsg': lastMsg,
      'lastMsgTime': FieldValue.serverTimestamp(),
      'unSeenMsgCount': unSeenMsgCount,
      'isMsgSeen': isMsgSeen,
      'lastSeen': lastSeen,
      'isOnline': isOnline,
    };
  }

  SDMap toMapLocal() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'image': image,
      'bio': bio,
      'lastMsg': lastMsg,
      'lastMsgTime': lastMsgTime?.millisecondsSinceEpoch,
      'unSeenMsgCount': unSeenMsgCount,
      'isMsgSeen': isMsgSeen,
      'lastSeen': lastSeen,
      'isOnline': isOnline,
    };
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
