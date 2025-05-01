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
    required LocalUser user,
    required Chat chat,
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
    required Chat chat,
    required String message,
  }) async {
    try {
      await DatasourceUtils.authorizeUser(_auth);

      final msgTime = Timestamp.now().toDate();

      final messageModel = MessageModel(
        msg: message,
        msgTime: msgTime,
        senderId: user.uid,
        recieverId: chat.uid,
        senderName: user.name,
        recieverName: chat.name,
        senderEmail: user.email,
        recieverEmail: chat.email,
        senderImage: user.image!,
        recieverImage: chat.image!,
      );

      final ids = [messageModel.senderId, messageModel.recieverId]..sort();
      final docId = ids.join('_');

      if (kDebugMode) print('..... Adding message in chats collection .....');

      await _firestore
          .collection('chats')
          .doc(docId)
          .collection('messages')
          .add(messageModel.toMap());

      if (kDebugMode) print('..... Adding chat in users collection .....');

      final userChatsRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('chats');

      final userRef =
          await userChatsRef.where('uid', isEqualTo: chat.uid).limit(1).get();

      if (userRef.docs.isEmpty) {
        final chatModel = ChatModel(
          uid: chat.uid,
          email: chat.email,
          name: chat.name,
          image: chat.image,
          bio: chat.bio,
          lastMsg: message,
          lastMsgTime: msgTime,
        );
        await userChatsRef.doc(chat.uid).set(chatModel.toMap());
      } else {
        await userChatsRef.doc(chat.uid).update({
          'lastMsg': message,
          'lastMsgTime': msgTime,
        });
      }

      final chatChatssRef = _firestore
          .collection('users')
          .doc(chat.uid)
          .collection('chats');

      final chatRef =
          await chatChatssRef.where('uid', isEqualTo: user.uid).limit(1).get();

      if (chatRef.docs.isEmpty) {
        // Create a new chat entry if it doesn't exist
        final userChatModel = ChatModel(
          uid: user.uid,
          name: user.name,
          email: user.email,
          image: user.image,
          bio: user.bio,
          lastMsg: message,
          lastMsgTime: msgTime,
          isMsgSeen: false,
          unSeenMsgCount: 1,
        );

        await chatChatssRef.doc(user.uid).set(userChatModel.toMap());
      } else {
        final docId = chatRef.docs.first.id;
        final existingData = chatRef.docs.first.data();
        final isSeen = existingData['isMsgSeen'] as bool;

        await chatChatssRef.doc(docId).update({
          'lastMsg': message,
          'lastMsgTime': msgTime,
          'isMsgSeen': false,
          'unSeenMsgCount': isSeen ? 1 : FieldValue.increment(1),
        });
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
