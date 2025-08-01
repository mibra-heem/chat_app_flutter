import 'package:equatable/equatable.dart';

class RemoteContact extends Equatable {
  const RemoteContact({
    required this.uid,
    required this.phone,
    required this.name,
    this.avatar,
    this.bio,
  });

  const RemoteContact.empty()
    : this(uid: '', phone: '', name: '');

  final String uid;
  final String name;
  final String phone;
  final String? avatar;
  final String? bio;

  bool get isEmpty => phone.isEmpty;
  bool get isNotEmpty => phone.isNotEmpty;

  @override
  List<Object?> get props => [uid, name, phone];

  @override
  String toString() {
    return 'RemoteContact{uid: $uid, name: $name, phone: $phone}';
  }
}
