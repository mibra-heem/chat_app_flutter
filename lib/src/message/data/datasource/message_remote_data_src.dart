import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/utils/datasource_utils.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/contact/data/model/contact_model.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';
import 'package:mustye/src/message/data/model/message_model.dart';
import 'package:mustye/src/message/domain/entity/message.dart';

abstract class MessageRemoteDataSrc {
  const MessageRemoteDataSrc();
  Future<void> sendMessage({
    required LocalUser user,
    required Contact contact,
    required String message,
  });
}

class MessageRemoteDataSrcImpl implements MessageRemoteDataSrc {
  const MessageRemoteDataSrcImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Future<void> sendMessage({
    required LocalUser user,
    required Contact contact,
    required String message,
  }) async {
    try {
      await DatasourceUtils.authorizeUser(_auth);

      // final user = _auth.currentUser!;
      final messageModel = MessageModel(
        msg: message,
        msgTime: Timestamp.now().toDate(),
        senderId: user.uid,
        recieverId: contact.uid,
        senderName: user.fullName,
        recieverName: contact.fullName,
        senderEmail: user.email,
        recieverEmail: contact.email,
        senderImage: user.image!,
        recieverImage: contact.image!,
      );

      final ids = [messageModel.senderId, messageModel.recieverId]..sort();
      final docId = ids.join('_');

      if (kDebugMode) print('..... Adding message in chats collection .....');

      await _firestore
          .collection('chats')
          .doc(docId)
          .collection('messages')
          .add(messageModel.toMap());

      if (kDebugMode) print('..... Adding contact in users collection .....');

      // Query contacts collection for both uids
      final snapshot =
          await _firestore
              .collection('contacts')
              .where('uid', whereIn: [contact.uid, user.uid])
              .get();

      final userModel = ContactModel(
        uid: user.uid,
        email: user.email,
        fullName: user.fullName,
        image: user.image,
        bio: user.bio,
      );

      final contactModel = ContactModel(
        uid: contact.uid,
        email: contact.email,
        fullName: contact.fullName,
        image: contact.image,
        bio: contact.bio,
      );

      // References to user and contact documents in users collection
      final userRef = _firestore.collection('users').doc(user.uid);
      final contactRef = _firestore.collection('users').doc(contact.uid);

      // Get snapshots for user and contact
      final userSnapshot = await userRef.get();
      final contactSnapshot = await contactRef.get();

      // Convert user's contacts list
      final userContacts =
          (userSnapshot.data()?['contacts'] as List<dynamic>?)?.map((item) {
            return ContactModel.fromMap(Map<String, dynamic>.from(item as Map));
          }).toList() ??
          [];

      // Convert contact's contacts list
      final contactContacts =
          (contactSnapshot.data()?['contacts'] as List<dynamic>?)?.map((item) {
            return ContactModel.fromMap(Map<String, dynamic>.from(item as Map));
          }).toList() ??
          [];

      // Check if the contact exists in both lists
      final userHasContact = userContacts.any(
        (c) => c.uid == contact.uid,
      );
      final contactHasUser = contactContacts.any((c) => c.uid == user.uid);

      // Create maps for updates
      final contactMap = contactModel.toMap();
      final userMap = userModel.toMap();

      // Update both sides if contact doesn't exist
      if (!userHasContact || !contactHasUser) {
        if (!userHasContact) {
          await userRef.update({
            'contacts': FieldValue.arrayUnion([contactMap]),
          });
        }
        if (!contactHasUser) {
          await contactRef.update({
            'contacts': FieldValue.arrayUnion([userMap]),
          });
        }
      } else {
        if (kDebugMode) {
          print(
            'Contact with uid ${contactModel.uid} already exists in both lists.',
          );
        }
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
