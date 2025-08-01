import 'package:contacts_service_plus/contacts_service_plus.dart';
import 'package:mustye/src/contact/data/models/local_contact_model.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactService {
  static Future<List<LocalContactModel>> getFilteredContacts() async {
    final status = await Permission.contacts.status;

    if (!status.isGranted) {
      final result = await Permission.contacts.request();
      if (!result.isGranted) return [];
    }

    final contacts = await ContactsService.getContacts(
      withThumbnails: false,
      iOSLocalizedLabels: false,
    );

    final filtered = contacts.where((c) {
      final hasName = c.displayName?.trim().isNotEmpty ?? false;
      final hasPhone = c.phones?.any(
        (p) => p.value?.trim().isNotEmpty ?? false
      ) ?? false;
      return hasName && hasPhone;
    }).map(LocalContactModel.fromContact).toList();

    return filtered;
  }
}
