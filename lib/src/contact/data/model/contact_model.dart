import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';

class ContactModel extends Contact {
  const ContactModel({
    required super.uid,
    required super.email,
    required super.fullName,
    super.image,
    super.bio,
    super.lastSeen,
    super.isOnline = false,
    super.fcmToken,
  });

  const ContactModel.empty() : super.empty();

  ContactModel.fromMap(DataMap map)
    : super(
        uid: map['uid'] as String,
        email: map['email'] as String,
        fullName: map['fullName'] as String,
        image: map['image'] as String?,
        bio: map['bio'] as String?,
        lastSeen: map['bio'] as String?,
        isOnline: map['isOnline'] as bool,
        fcmToken: map['fcmToken'] as String?,
      );

  ContactModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? image,
    String? bio,
    String? lastSeen,
    bool? isOnline,
    String? fcmToken,
  }) {
    return ContactModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      image: image ?? this.image,
      bio: bio ?? this.bio,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  DataMap toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'image': image,
      'bio': bio,
      'lastSeen': lastSeen,
      'isOnline': isOnline,
      'fcmToken': fcmToken,
    };
  }
}
