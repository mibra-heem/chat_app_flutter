import 'package:flutter/material.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/chat/data/model/chat_model.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';

class LocalUserModel extends LocalUser{
  const LocalUserModel({
    required super.uid, 
    required super.phone,
    required super.name, 
    super.avatar,
    super.bio,
    super.chats,
    super.activeChatId,
    super.fcmToken,
  });

  const LocalUserModel.empty() : super.empty();

  LocalUserModel.fromMap(SDMap map) : super(
    uid:  map['uid'] as String,
    phone: map['phone'] as String,
    name: map['name'] as String,
    avatar: map['avatar'] as String?,
    bio: map['bio'] as String?,
    chats: map['chats'] != null 
      ? List<Chat>.from(
          (map['chats'] as List).map(
            (m) {
              debugPrint('LocalUserModel.fromMap chats are not null .....');
              final chat = SDMap.from(m as Map);
              return ChatModel.fromMap(chat);
            },
          ),
        )
      : const [],
    activeChatId: map['activeChatId']  as String?,
    fcmToken: map['fcmToken']  as String?,

  );

  LocalUserModel copyWith({
    String? uid, 
    String? phone,
    String? name, 
    String? avatar,
    String? bio,
    List<Chat>? chats,
    String? activeChatId,
    String? fcmToken,
  }){
    return LocalUserModel(
      uid: uid ?? this.uid,
      phone: phone ?? this.phone, 
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      chats: chats ?? this.chats,
      activeChatId: activeChatId ?? this.activeChatId,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  SDMap toMap(){
    return {
      'uid' : uid,
      'phone' : phone,
      'name' : name,
      'avatar' : avatar,
      'bio' : bio,
      'activeChatId' : activeChatId,
      'fcmToken' : fcmToken,
    };
  }

  SDMap toMapLocal(){
    return {
      'uid' : uid,
      'phone' : phone,
      'name' : name,
      'avatar' : avatar,
      'bio' : bio,
      'chats' : chats.map((m)=> (m as ChatModel).toMapLocal()).toList(),
      'activeChatId' : activeChatId,
      'fcmToken' : fcmToken,
    };
  }

}
