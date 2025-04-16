import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/contact/data/model/contact_model.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';

class LocalUserModel extends LocalUser{
  const LocalUserModel({
    required super.uid, 
    required super.email, 
    required super.fullName, 
    super.image,
    super.bio,
    super.contacts = const [],
  });

  const LocalUserModel.empty() : super.empty();

  LocalUserModel.fromMap(DataMap map) : super(
    uid:  map['uid'] as String, 
    email: map['email'] as String,
    fullName: map['fullName'] as String,
    image: map['image'] as String?,
    bio: map['bio'] as String?,
    contacts: map['contacts'] != null 
      ? List<Contact>.from(
          (map['contacts'] as List).map(
            (m) => ContactModel.fromMap(m as DataMap),
          ),
        )
      : const [],
  );

  LocalUserModel copyWith({
    String? uid, 
    String? email,
    String? fullName, 
    String? image,
    String? bio,
    List<Contact>? contacts,
  }){
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email, 
      fullName: fullName ?? this.fullName,
      image: image ?? this.image,
      bio: bio ?? this.bio,
      contacts: contacts ?? this.contacts,
    );
  }

  DataMap toMap(){
    return {
      'uid' : uid,
      'email' : email,
      'fullName' : fullName,
      'image' : image,
      'bio' : bio,
      'contacts' : contacts,
    };
  }

}
