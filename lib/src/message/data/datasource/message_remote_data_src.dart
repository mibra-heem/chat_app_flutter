import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
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
    required Box<dynamic> chatBox,
  }) : _auth = auth,
       _firestore = firestore,
       _chatBox = chatBox;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final Box<dynamic> _chatBox;

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

      final chatDocId = DatasourceUtils.joinIds(
        userId: sender.uid,
        chatId: reciever.uid,
      );

      // Add the message to the messages subcollection
      final messageDoc =
          _firestore
              .collection('chats')
              .doc(chatDocId)
              .collection('messages')
              .doc();
      await messageDoc.set(messageModel.toMap());

      // === Sender Chat Logic ===
      final senderChatRef = _firestore
          .collection('users')
          .doc(sender.uid)
          .collection('chats')
          .doc(reciever.uid);

      // === Receiver Chat Logic ===
      final receiverChatRef = _firestore
          .collection('users')
          .doc(reciever.uid)
          .collection('chats')
          .doc(sender.uid);

      final receiverDoc =
          await _firestore.collection('users').doc(reciever.uid).get();

      final receiverActiveChatId = receiverDoc.data()?['activeChatId'];
      final isReceiverViewingThisChat = receiverActiveChatId == sender.uid;

      if (!_chatBox.containsKey(chatDocId)) {
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
        await receiverChatRef.set(senderChatModel.toMap());

        debugPrint('Step-1 Sender ChatModel set in reciever chat ...........');

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

        debugPrint('Step-2 Reciever ChatModel set in sender chat ............');


        await _chatBox.put(chatDocId, chatDocId);

        debugPrint('Step-3 Chat Doc Id set ........................');

      } else {
        debugPrint('Step-1 Sender data update in reciever chat ...........');

        await receiverChatRef.update({
          'lastMsg': message,
          'lastMsgTime': msgTime,
          'unSeenMsgCount':
              isReceiverViewingThisChat ? 0 : FieldValue.increment(1),
        });

        debugPrint('Step-2 Reciever data update in sender chat ............');

        await senderChatRef.update({
          'lastMsg': message,
          'lastMsgTime': msgTime,
        });
      }

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
