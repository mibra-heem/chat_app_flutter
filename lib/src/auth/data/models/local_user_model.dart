import 'package:flutter/material.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/chat/data/model/chat_model.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';

class LocalUserModel extends LocalUser{
  const LocalUserModel({
    required super.uid, 
    required super.email, 
    required super.name, 
    super.image,
    super.bio,
    super.chats,
    super.activeChatId,
    super.fcmToken,
  });

  const LocalUserModel.empty() : super.empty();

  LocalUserModel.fromMap(SDMap map) : super(
    uid:  map['uid'] as String,
    email: map['email'] as String,
    name: map['name'] as String,
    image: map['image'] as String?,
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
    String? email,
    String? name, 
    String? image,
    String? bio,
    List<Chat>? chats,
    String? activeChatId,
    String? fcmToken,
  }){
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email, 
      name: name ?? this.name,
      image: image ?? this.image,
      bio: bio ?? this.bio,
      chats: chats ?? this.chats,
      activeChatId: activeChatId ?? this.activeChatId,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  SDMap toMap(){
    return {
      'uid' : uid,
      'email' : email,
      'name' : name,
      'image' : image,
      'bio' : bio,
      'activeChatId' : activeChatId,
      'fcmToken' : fcmToken,
    };
  }

  SDMap toMapLocal(){
    return {
      'uid' : uid,
      'email' : email,
      'name' : name,
      'image' : image,
      'bio' : bio,
      'chats' : chats.map((m)=> (m as ChatModel).toMapLocal()).toList(),
      'activeChatId' : activeChatId,
      'fcmToken' : fcmToken,
    };
  }

}
