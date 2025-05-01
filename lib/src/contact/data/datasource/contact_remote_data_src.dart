import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/utils/datasource_utils.dart';
import 'package:mustye/src/contact/data/model/contact_model.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';

abstract class ContactRemoteDataSrc {
  const ContactRemoteDataSrc();

  Future<List<Contact>> getContacts();
  Future<void> addContact(Contact contact);
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
  Future<List<Contact>> getContacts() async {
    try {
      await DatasourceUtils.authorizeUser(_auth);
      return _firestore
          .collection('contacts')
          .where('uid', isNotEqualTo: _auth.currentUser!.uid)
          .get()
          .then(
            (value) =>
                value.docs
                    .map((doc) => ContactModel.fromMap(doc.data()))
                    .toList(),
          );
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
  Future<void> addContact(Contact contact) async {
    try {
      await DatasourceUtils.authorizeUser(_auth);

      final user = _auth.currentUser!;
      final contactModel = contact as ContactModel;
      final userRef = _firestore.collection('users').doc(user.uid);
      final chatsRef = userRef.collection('chats');
      final existingChat = await chatsRef.where('uid', isEqualTo: contact.uid)
        .limit(1).get();
      if(existingChat.docs.isEmpty){
        await chatsRef.add(contactModel.toMap());
      }else{
        if(kDebugMode) print('Chat with ${contact.email} already exists.');
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
