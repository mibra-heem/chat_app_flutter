import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';

class ContactModel extends Contact {
  const ContactModel({
    required super.uid,
    required super.email,
    required super.name,
    super.image,
    super.bio,
  });

  const ContactModel.empty() : super.empty();

  ContactModel.fromMap(SDMap map)
    : super(
        uid: map['uid'] as String,
        email: map['email'] as String,
        name: map['name'] as String,
        image: map['image'] as String?,
        bio: map['bio'] as String?,
      );

  ContactModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? image,
    String? bio,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unSeenMsgCount,
    bool? isMessageSeen,
    String? lastSeen,
    bool? isOnline,
    String? fcmToken,
  }) {
    return ContactModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      image: image ?? this.image,
      bio: bio ?? this.bio,
    );
  }

  SDMap toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'image': image,
      'bio': bio,
    };
  }
}
