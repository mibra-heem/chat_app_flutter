import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';

class ChatModel extends Chat{
  const ChatModel({
    required super.id, 
    required super.name, 
    required super.image, 
    required super.email,
  });

  const ChatModel.empty() : super.empty();

  ChatModel.fromMap(DataMap map)
    : super(
        id: map['id'] as String,
        name: map['name'] as String,
        image: map['image'] as String,
        email: map['email'] as String,
      );

  ChatModel copyWith({
    String? id,
    String? name,
    String? image,
    String? email,
  }) {
    return ChatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      email: email ?? this.email,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'email': email,
    };
  }

  
}
