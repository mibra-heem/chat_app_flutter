import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/utils/datasource_utils.dart';
import 'package:mustye/src/contact/data/models/contact_model.dart';
import 'package:mustye/src/contact/data/models/remote_contact_model.dart';
import 'package:mustye/src/contact/domain/entities/local_contact.dart';
import 'package:mustye/src/contact/domain/entities/remote_contact.dart';

abstract class ContactRemoteDataSrc {
  const ContactRemoteDataSrc();

  Future<List<RemoteContact>> getContacts();
  Future<void> addContact(LocalContact contact);
}

class ContactRemoteDataSrcImpl implements ContactRemoteDataSrc {
  const ContactRemoteDataSrcImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Future<List<RemoteContact>> getContacts() async {
    try {
      DatasourceUtils.authorizeUser(_auth);

      final snapshot = await _firestore.collection('users').get();

      final contacts = <RemoteContact>[];
      if (snapshot.docs.isNotEmpty) {
        for (final doc in snapshot.docs) {
          contacts.add(RemoteContactModel.fromMap(doc.data()));
        }
      }

      return contacts;
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? '');
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      if (kDebugMode) print('.......... Exception $e.........');
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> addContact(LocalContact contact) async {
    try {
      DatasourceUtils.authorizeUser(_auth);

      final user = _auth.currentUser!;
      final contactModel = contact as LocalContactModel;
      final userRef = _firestore.collection('users').doc(user.uid);
      final chatsRef = userRef.collection('chats');
      final existingChat =
          await chatsRef.where('uid', isEqualTo: contact.uid).limit(1).get();
      if (existingChat.docs.isEmpty) {
        // await chatsRef.add(contactModel.toMap());
      } else {
        // if(kDebugMode) print('Chat with ${contact.email} already exists.');
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? '');
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      if (kDebugMode) print('.......... Exception $e.........');
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
