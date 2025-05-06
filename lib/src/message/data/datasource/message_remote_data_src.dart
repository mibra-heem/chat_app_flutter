import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/utils/datasource_utils.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/chat/data/model/chat_model.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/message/data/model/message_model.dart';

abstract class MessageRemoteDataSrc {
  const MessageRemoteDataSrc();
  Future<void> sendMessage({
    required LocalUser sender,
    required Chat reciever,
    required String message,
  });

  Future<void> setActiveChatId({required String? activeChatId});
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
    required LocalUser sender,
    required Chat reciever,
    required String message,
  }) async {
    try {
      await DatasourceUtils.authorizeUser(_auth);

      final msgTime = Timestamp.now().toDate();

      final messageModel = MessageModel(
        msg: message,
        msgTime: msgTime,
        senderId: sender.uid,
        recieverId: reciever.uid,
      );

      final ids = [sender.uid, reciever.uid]..sort();
      final chatDocId = ids.join('_');

      // Add the message to the messages subcollection
      final messageDoc =
          _firestore
              .collection('chats')
              .doc(chatDocId)
              .collection('messages')
              .doc();
      await messageDoc.set(messageModel.toMap());

      // final batch = _firestore.batch();

      // === Receiver Chat Logic ===
      final receiverChatRef = _firestore
          .collection('users')
          .doc(reciever.uid)
          .collection('chats')
          .doc(sender.uid);

      // Fetch both chat snap and user doc together
      final results = await Future.wait([
        receiverChatRef.get(),
        _firestore.collection('users').doc(reciever.uid).get(),
      ]);

      final receiverChatSnap = results[0];
      final receiverDoc = results[1];

      final receiverActiveChatId = receiverDoc.data()?['activeChatId'];
      final isReceiverViewingThisChat = receiverActiveChatId == sender.uid;

      if (!receiverChatSnap.exists) {
        final senderChatModel = ChatModel(
          uid: sender.uid,
          email: sender.email,
          name: sender.name,
          image: sender.image,
          bio: sender.bio,
          lastMsg: message,
          lastMsgTime: msgTime,
          unSeenMsgCount: isReceiverViewingThisChat ? 0 : 1,
        );

        // Set basic data
        await receiverChatRef.set(senderChatModel.toMap());
        // await batch.commit();
      } else {
        await receiverChatRef.update({
          'lastMsg': message,
          'lastMsgTime': msgTime,
          'unSeenMsgCount':
              isReceiverViewingThisChat ? 0 : FieldValue.increment(1),
        });
      }

      // === Sender Chat Logic ===
      final senderChatRef = _firestore
          .collection('users')
          .doc(sender.uid)
          .collection('chats')
          .doc(reciever.uid);

      final senderChatSnap = await senderChatRef.get();
      if (!senderChatSnap.exists) {
        final recieverChatModel = ChatModel(
          uid: reciever.uid,
          email: reciever.email,
          name: reciever.name,
          image: reciever.image,
          bio: reciever.bio,
          lastMsg: message,
          lastMsgTime: msgTime,
        );
        await senderChatRef.set(recieverChatModel.toMap());
      } else {
        await senderChatRef.update({
          'lastMsg': message,
          'lastMsgTime': msgTime,
        });
      }

      // Commit all changes
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? '');
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> setActiveChatId({required String? activeChatId}) async {
    try {
      await DatasourceUtils.authorizeUser(_auth);

      final currentUserId = _auth.currentUser!.uid;

      // Always update the user document, even if null
      await _firestore.collection('users').doc(currentUserId).update({
        'activeChatId': activeChatId,
      });

      // If chat is deactivated, stop here
      if (activeChatId == null) return;

      final docId = [currentUserId, activeChatId]..sort();
      final chatId = docId.join('_');

      final docs =
          await _firestore
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .where('recieverId', isEqualTo: currentUserId)
              .where('isSeen', isEqualTo: false)
              .get();

      // Mark messages as seen
      final batch = _firestore.batch();
      for (final doc in docs.docs) {
        debugPrint('............ Updating messages seen flag ...........');

        batch.update(doc.reference, {'isSeen': true});
      }
      await batch.commit();
      debugPrint('............ batch commited ...........');
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
