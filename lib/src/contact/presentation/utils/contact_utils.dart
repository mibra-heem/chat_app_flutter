import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/src/contact/data/model/contact_model.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';

class ContactUtils {
  const ContactUtils._();

  static Stream<List<Contact>> get getContacts => sl<FirebaseFirestore>()
  .collection('contacts')
  .where('uid', isNotEqualTo: sl<FirebaseAuth>().currentUser!.uid)
  .snapshots()
  .map(
    (snapshot) => snapshot.docs.map(
      (doc) =>  ContactModel.fromMap(doc.data()),
    ).toList(),
  ); 
}
