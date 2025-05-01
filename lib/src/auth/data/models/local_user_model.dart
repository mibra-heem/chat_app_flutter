import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/chat/data/model/chat_model.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/contact/data/model/contact_model.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';

class LocalUserModel extends LocalUser{
  const LocalUserModel({
    required super.uid, 
    required super.email, 
    required super.name, 
    super.image,
    super.bio,
    super.chats = const [],
  });

  const LocalUserModel.empty() : super.empty();

  LocalUserModel.fromMap(DataMap map) : super(
    uid:  map['uid'] as String,
    email: map['email'] as String,
    name: map['name'] as String,
    image: map['image'] as String?,
    bio: map['bio'] as String?,
    chats: map['chats'] != null 
      ? List<Chat>.from(
          (map['chats'] as List).map(
            (m) {
              final chat = DataMap.from(m as Map);
              return ChatModel.fromMap(chat);
            },
          ),
        )
      : const [],
  );

  LocalUserModel copyWith({
    String? uid, 
    String? email,
    String? name, 
    String? image,
    String? bio,
    List<Chat>? chats,
  }){
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email, 
      name: name ?? this.name,
      image: image ?? this.image,
      bio: bio ?? this.bio,
      chats: chats ?? this.chats,
    );
  }

  DataMap toMap(){
    return {
      'uid' : uid,
      'email' : email,
      'name' : name,
      'image' : image,
      'bio' : bio,
    };
  }

}
