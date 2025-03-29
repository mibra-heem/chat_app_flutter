import 'package:equatable/equatable.dart';

class LocalUser extends Equatable{

  const LocalUser({
    required this.uid,
    required this.email,
    required this.points,
    required this.fullName,
    this.groupIds = const [],
    this.enrolledCourseIds = const [],
    this.followers = const [],
    this.following = const [],
    this.image,
    this.bio,
  });

  const LocalUser.empty() : this(
    email: '',
    fullName: '',
    uid: '',
    points: 0,
    groupIds: const [],
    enrolledCourseIds: const [],
    followers: const [],
    following: const [],
    image: '',
    bio: '',
  );

  final String uid;
  final String email;
  final String? image;
  final String? bio;
  final int points;
  final String fullName;
  final List<String> groupIds;
  final List<String> enrolledCourseIds;
  final List<String> following;
  final List<String> followers;

  bool get isAdmin => email == 'moonrj222@gmail.com';

  @override
  List<Object?> get props => [
    uid, email, image, bio, points, fullName, groupIds, enrolledCourseIds,
    followers, following,
  ];

  @override
  String toString(){
    return 'UserEntity{id: $uid, email: $email, bio: $bio, '
    'points: $points, fullName: $fullName}';
  }


}
