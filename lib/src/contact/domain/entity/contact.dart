import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  const Contact({
    required this.uid,
    required this.email,
    required this.name,
    this.image,
    this.bio,
  });

  const Contact.empty() : this(uid: '', email: '', name: '', image: '');

  final String uid;
  final String email;
  final String? image;
  final String? bio;
  final String name;

  @override
  List<Object?> get props => [uid, email, name, image, bio];

  @override
  String toString() {
    return 'Contact{uid: $uid, email: $email, name: $name, bio: $bio}';
  }
}
