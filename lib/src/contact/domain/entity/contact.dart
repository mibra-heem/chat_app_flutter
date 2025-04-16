import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  const Contact({
    required this.uid,
    required this.email,
    required this.fullName,
    this.image,
    this.bio,
    this.lastSeen,
    this.isOnline = false,
    this.fcmToken,
  });

  const Contact.empty()
      : this(
          uid: '',
          email: '',
          fullName: '',
          image: '',
          bio: '',
          lastSeen: null,
          fcmToken: '',
        );

  final String uid;
  final String email;
  final String? image;
  final String? bio;
  final String fullName;
  final String? lastSeen;
  final bool isOnline;
  final String? fcmToken;

  @override
  List<Object?> get props => [
        uid,
        email,
        fullName,
        image,
        bio,
      ];

  @override
  String toString() {
    return 'Contact{uid: $uid, email: $email, fullName: $fullName, bio: $bio}';
  }
}
