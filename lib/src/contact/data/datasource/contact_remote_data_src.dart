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
  Future<void> startChat(Contact contact);
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
  Future<void> startChat(Contact contact) async {
    try {
      await DatasourceUtils.authorizeUser(_auth);

      final user = _auth.currentUser!;
      final contactModel = contact as ContactModel;
      final userRef = _firestore.collection('users').doc(user.uid);
      final chatsRef = userRef.collection('chats');
      final existingChat = await chatsRef.where('uid', isEqualTo: contact.uid)
        .limit(1).get();
      if(existingChat.docs.isEmpty){
        await chatsRef.doc().set(contactModel.toMap());
      }else{
        if(kDebugMode) print('Chat with ${contact.email} already exists.');
      }

      // final sender =
      //     await _firestore
      //         .collection('messages')
      //         .withConverter<Message>(
      //           fromFirestore:
      //               (snapshot, _) => MessageModel.fromMap(snapshot.data()!),
      //           toFirestore: (msg, _) => (msg as MessageModel).toMap(),
      //         )
      //         .where('senderId', isEqualTo: user.uid)
      //         .where('recieverId', isEqualTo: contact.uid)
      //         .get();

      // final reciever =
      //     await _firestore
      //         .collection('messages')
      //         .withConverter<Message>(
      //           fromFirestore:
      //               (snapshot, _) => MessageModel.fromMap(snapshot.data()!),
      //           toFirestore: (msg, _) => (msg as MessageModel).toMap(),
      //         )
      //         .where('senderId', isEqualTo: contact.uid)
      //         .where('recieverId', isEqualTo: _auth.currentUser!.uid)
      //         .get();

      // if (sender.docs.isEmpty && reciever.docs.isEmpty) {

      //   final msg = MessageModel(
      //     msg: '',
      //     msgTime: Timestamp.now().toDate(),
      //     msgNum: 0,
      //     senderId: user.uid,
      //     recieverId: contact.uid,
      //     senderName: user.displayName!,
      //     recieverName: contact.fullName,
      //     senderImage: user.photoURL!,
      //     recieverImage: contact.image!,
      //   );

      //   final msgDoc = await _firestore
      //       .collection('messages')
      //       .withConverter<Message>(
      //         fromFirestore:
      //             (snapshot, _) => MessageModel.fromMap(snapshot.data()!),
      //         toFirestore: (msg, _) => (msg as MessageModel).toMap(),
      //       )
      //       .add(msg);

      //   if(kDebugMode) print('.... New chat with ${contact.email} added.');

      //   return Chat(
      //     id : contact.uid,
      //     name : contact.fullName,
      //     image : contact.image ?? '',
      //     msgDocId: msgDoc.id,
      //   );
        
      // } else {
      //   if(kDebugMode) print('.... Chat with ${contact.email} already exists.');
      //   return const Chat.empty();
      // }
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
