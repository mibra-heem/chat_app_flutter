import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/utils/datasource_utils.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';

abstract class ChatRemoteDataSrc {
  const ChatRemoteDataSrc();

  Future<void> deleteChat(List<Chat> chat);
  Future<void> messageSeen({required String senderUid});
}

class ChatRemoteDataSrcImpl implements ChatRemoteDataSrc {
  const ChatRemoteDataSrcImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Future<void> messageSeen({required String senderUid}) async {
    try {
      DatasourceUtils.authorizeUser(_auth);

      final chatDocRef = _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('chats')
          .doc(senderUid);

      final docSnapshot = await chatDocRef.get();

      if (docSnapshot.exists) {
        await chatDocRef.update({'isMsgSeen': true, 'unSeenMsgCount': 0});
      } else {
        // Optionally create the document or handle gracefully
        print('Chat document with $senderUid does not exist.');
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

  @override
  Future<void> deleteChat(List<Chat> chat) async {
    try {
      DatasourceUtils.authorizeUser(_auth);

      for (var i = 0; i < chat.length; i++) {
        final user = _auth.currentUser!;
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('chats')
            .doc(chat[i].uid)
            .delete();

        await _firestore
            .collection('users')
            .doc(chat[i].uid)
            .collection('chats')
            .doc(user.uid)
            .delete();

        await deleteMessages(user.uid, chat[i].uid);

        if (kDebugMode) {
          print(
            'ChatId => ${DatasourceUtils.joinIds(userId: user.uid, chatId: chat[i].uid)}',
          );

          print('Chat deleted => ${chat[i]}');
        }
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? '');
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      if (kDebugMode) print('.......... Exception $e.........');
      throw ServerException(
        message: e.toString(),
        statusCode: 'error-while-deleting-chat',
      );
    }
  }

  Future<void> deleteMessages(String currentUserId, String otherUserId) async {
    final chatDocId = DatasourceUtils.joinIds(
      userId: currentUserId,
      chatId: otherUserId,
    );
    final chatDocRef = _firestore.collection('chats').doc(chatDocId);
    final messagesRef = chatDocRef.collection('messages');

    // Delete all message documents first
    final messagesSnapshot = await messagesRef.get();
    for (final doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }

    // Now delete the chat document itself
    await chatDocRef.delete();
  }
}
