
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';

class LocalUserModel extends LocalUser{
  const LocalUserModel({
    required super.uid, 
    required super.email, 
    required super.fullName, 
    super.image,
    super.bio,
  });

  const LocalUserModel.empty() : this(
    uid: '', email: '', fullName: '',
  );

  LocalUserModel.fromMap(DataMap map) : super(
    uid:  map['uid'] as String, 
    email: map['email'] as String,
    fullName: map['fullName'] as String,
    image: map['image'] as String?,
    bio: map['bio'] as String?,
  );

  get enrolledCourseIds => null;

  LocalUserModel copyWith({
    String? uid, 
    String? email,
    String? fullName, 
    String? image,
    String? bio,
  }){
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email, 
      fullName: fullName ?? this.fullName,
      image: image ?? this.image,
      bio: bio ?? this.bio,
    );
  }

  DataMap toMap(){
    return {
      'uid' : uid,
      'email' : email,
      'fullName' : fullName,
      'image' : image,
      'bio' : bio,
    };
  }

}
