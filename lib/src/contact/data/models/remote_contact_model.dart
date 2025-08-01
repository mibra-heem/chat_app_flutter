import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/contact/domain/entities/remote_contact.dart';

class RemoteContactModel extends RemoteContact {

  const RemoteContactModel({
    required super.uid,
    required super.name,
    required super.phone,
    super.avatar,
    super.bio,
  });

  factory RemoteContactModel.fromMap(SDMap contact) {

    return RemoteContactModel(
      uid: contact['uid'] as String,
      name: contact['name'] as String,
      phone: contact['phone'] as String,
      avatar: contact['avatar'] as String?,
      bio: contact['bio'] as String?,
    );
  }
}
