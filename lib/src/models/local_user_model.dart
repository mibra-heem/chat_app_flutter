
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/entities/local_user.dart';

class LocalUserModel extends LocalUser{
  const LocalUserModel({
    required super.uid, 
    required super.email, 
    required super.points, 
    required super.fullName, 
    super.image,
    super.bio,
    super.groupIds, 
    super.enrolledCourseIds, 
    super.followers, 
    super.following,
  });

  const LocalUserModel.empty() : this(
    uid: '', email: '', fullName: '', points: 0,
  );

  LocalUserModel.fromMap(DataMap map) : super(
    uid:  map['uid'] as String, 
    email: map['email'] as String,
    fullName: map['fullName'] as String,
    points: (map['points'] as num).toInt(),
    image: map['image'] as String?,
    bio: map['bio'] as String?,
    groupIds: (map['groupIds'] as List<dynamic>).cast<String>(),
    enrolledCourseIds: (
      map['enrolledCourseIds'] as List<dynamic>
    ).cast<String>(),
    followers: (map['followers'] as List<dynamic>).cast<String>(),
    following: (map['following'] as List<dynamic>).cast<String>(),
  );

  LocalUserModel copyWith({
    String? uid, 
    String? email,
    String? fullName, 
    String? image,
    String? bio,
    int? points, 
    List<String>? groupIds, 
    List<String>? enrolledCourseIds, 
    List<String>? followers, 
    List<String>? following,
  }){
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email, 
      points: points ?? this.points, 
      fullName: fullName ?? this.fullName,
      image: image ?? this.image,
      bio: bio ?? this.bio,
      groupIds: groupIds ?? this.groupIds,
      enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }

  DataMap toMap(){
    return {
      'uid' : uid,
      'email' : email,
      'fullName' : fullName,
      'points' : points,
      'image' : image,
      'bio' : bio,
      'groupIds' : groupIds,
      'enrolledCourseIds' : enrolledCourseIds,
      'followers' : followers,
      'following' : following,
    };
  }

}
