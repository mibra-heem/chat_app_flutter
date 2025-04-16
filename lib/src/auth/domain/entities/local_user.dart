import 'package:equatable/equatable.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';

class LocalUser extends Equatable{

  const LocalUser({
    required this.uid,
    required this.email,
    required this.fullName,
    this.image,
    this.bio,
    this.contacts = const [],
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
  final List<Contact> contacts; 

  @override
  List<Object?> get props => [
    uid, email, fullName, image, bio, contacts,
  ];

  @override
  String toString(){
    return 'LocalUser{id: $uid, email: $email, bio: $bio, ' 
    'fullName: $fullName, image: $image, contacts: $contacts}';
  }


}
