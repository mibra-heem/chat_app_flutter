import 'package:equatable/equatable.dart';

class LocalUser extends Equatable{

  const LocalUser({
    required this.uid,
    required this.email,
    required this.fullName,
    this.image,
    this.bio,
  });

  const LocalUser.empty() : this(
    email: '',
    fullName: '',
    uid: '',
    image: '',
    bio: '',
  );

  final String uid;
  final String fullName;
  final String email;
  final String? image;
  final String? bio;


  bool get isAdmin => email == 'moonrj222@gmail.com';

  @override
  List<Object?> get props => [
    uid, email, fullName, image, bio, 
  ];

  @override
  String toString(){
    return 'LocalUser{id: $uid, email: $email, bio: $bio, ' 
    'fullName: $fullName, image: $image}';
  }


}
