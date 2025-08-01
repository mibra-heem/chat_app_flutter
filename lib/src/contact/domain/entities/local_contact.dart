import 'package:equatable/equatable.dart';

class LocalContact extends Equatable {
  const LocalContact({
    required this.uid,
    required this.phone,
    required this.name,
  });

  const LocalContact.empty()
    : this(uid: '', phone: '', name: '');

  final String uid;
  final String name;
  final String phone;

  @override
  List<Object?> get props => [uid, name, phone];

  @override
  String toString() {
    return 'Contact{uid: $uid, name: $name, phone: $phone}';
  }
}
