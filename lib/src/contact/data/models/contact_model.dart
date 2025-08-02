import 'package:contacts_service_plus/contacts_service_plus.dart';
import 'package:mustye/src/contact/domain/entities/local_contact.dart';

class LocalContactModel extends LocalContact {

  const LocalContactModel({
    required super.uid,
    required super.name,
    required super.phone,
  });

  factory LocalContactModel.fromContact(Contact contact) {
    final name = contact.displayName ?? '';
    final phone = contact.phones?.firstOrNull?.value ?? '';

    if (name.isEmpty || phone.isEmpty) {
      throw Exception('Invalid contact');
    }

    return LocalContactModel(
      uid: contact.identifier ?? '${name}_$phone', // fallback
      name: name,
      phone: phone,
    );
  }
}
