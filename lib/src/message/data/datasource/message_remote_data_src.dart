import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:mustye/core/config/api_config.dart';
import 'package:mustye/core/config/route_config.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/services/api_service.dart';
import 'package:mustye/core/services/notification_service.dart';
import 'package:mustye/core/utils/datasource_utils.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/chat/data/model/chat_model.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/message/data/model/message_model.dart';
import 'package:mustye/src/message/domain/entity/message.dart';

abstract class MessageRemoteDataSrc {
  const MessageRemoteDataSrc();
  Future<void> sendMessage({
    required LocalUser sender,
    required Chat reciever,
    required String message,
  });
  Future<void> deleteMessages({
    required List<Message> messages,
    required String chatId,
  });
  Future<void> setActiveChatId({required String? activeChatId});
}

class MessageRemoteDataSrcImpl implements MessageRemoteDataSrc {
  const MessageRemoteDataSrcImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required Box<dynamic> chatBox,
    required ApiService apiClient,
  }) : _auth = auth,
       _firestore = firestore,
       _chatBox = chatBox,
       _apiClient = apiClient;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final Box<dynamic> _chatBox;
  final ApiService _apiClient;

  @override
  Future<void> sendMessage({
    required LocalUser sender,
    required Chat reciever,
    required String message,
  }) async {
    try {
      // Authorizing the user
      DatasourceUtils.authorizeUser(_auth);

      //Setting message data into the firestore
      final msgTime = Timestamp.now().toDate();

      final chatDocId = DatasourceUtils.joinIds(
        userId: sender.uid,
        chatId: reciever.uid,
      );
      final messageDocRef =
          _firestore
              .collection('chats')
              .doc(chatDocId)
              .collection('messages')
              .doc();

      final messageModel = MessageModel(
        uid: messageDocRef.id,
        msg: message,
        msgTime: msgTime,
        senderId: sender.uid,
        recieverId: reciever.uid,
      );

      await messageDocRef.set(messageModel.toMap());

      final receiverDoc =
          await _firestore.collection('users').doc(reciever.uid).get();

      // Updating the chats subcollection of sender and reciever
      final senderChatRef = _firestore
          .collection('users')
          .doc(sender.uid)
          .collection('chats')
          .doc(reciever.uid);

      final receiverChatRef = _firestore
          .collection('users')
          .doc(reciever.uid)
          .collection('chats')
          .doc(sender.uid);

      // Checking if reciever is on sender's message screen
      final receiverActiveChatId = receiverDoc.data()?['activeChatId'];
      final isReceiverViewingThisChat = receiverActiveChatId == sender.uid;

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

      final recieverChatModel = ChatModel(
        uid: reciever.uid,
        email: reciever.email,
        name: reciever.name,
        image: reciever.image,
        bio: reciever.bio,
        lastMsg: message,
        lastMsgTime: msgTime,
      );
      debugPrint('Reciever Chat exist or not? ${senderChatRef.id.isNotEmpty}');

      debugPrint('senderChatRef Id => ${senderChatRef.id}');

      final senderChatDocRef = await senderChatRef.get();

      debugPrint(
        'senderChatDocRef exist in forestore => ${senderChatDocRef.exists}',
      );

      // If both users are chatting for the first time => true
      if (!senderChatDocRef.exists) {
        await receiverChatRef.set(senderChatModel.toMap());

        await senderChatRef.set(recieverChatModel.toMap());
      } else {
        await receiverChatRef.update({
          'lastMsg': message,
          'lastMsgTime': msgTime,
          'unSeenMsgCount':
              isReceiverViewingThisChat ? 0 : FieldValue.increment(1),
        });

        await senderChatRef.update({
          'lastMsg': message,
          'lastMsgTime': msgTime,
        });
      }

      // Send Push Notification if reciever is not in the app

      final fcmToken = receiverDoc.data()?['fcmToken'] as String;

      await sendNotification(
        fcmToken: fcmToken,
        message: message,
        title: sender.name,
        chat: senderChatModel as Chat,
      );
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
      DatasourceUtils.authorizeUser(_auth);

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

  @override
  Future<void> deleteMessages({
    required List<Message> messages,
    required String chatId,
  }) async {
    try {
      DatasourceUtils.authorizeUser(_auth);

      final currentUserId = _auth.currentUser!.uid;

      final chatDocId = DatasourceUtils.joinIds(
        userId: currentUserId,
        chatId: chatId,
      );

      final batch = _firestore.batch();
      final chatDocRef = _firestore.collection('chats').doc(chatDocId);
      final messagesRef = chatDocRef.collection('messages');

      if (messages.isEmpty) return;

      var unseenCountDecrement = 0;
      for (final msg in messages) {
        final msgDocRef = messagesRef.doc(msg.uid);
        batch.delete(msgDocRef);
        if (!msg.isSeen) unseenCountDecrement++;

        debugPrint('Queued for deletion => ${msg.uid}');
      }

      await batch.commit(); // ❗ Commit deletions first

      // Now safely read the remaining latest message
      final remainingSnapshot =
          await messagesRef.orderBy('msgTime', descending: true).limit(1).get();

      final userChatDocRef = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('chats')
          .doc(chatId);

      final chatUserDocRef = _firestore
          .collection('users')
          .doc(chatId)
          .collection('chats')
          .doc(currentUserId);

      final updateBatch = _firestore.batch();

      if (remainingSnapshot.docs.isNotEmpty) {
        final newLastMessage = MessageModel.fromMap(
          remainingSnapshot.docs.first.data(),
        );

        updateBatch
          ..update(userChatDocRef, {
            'lastMsgTime': newLastMessage.msgTime,
            'lastMsg': newLastMessage.msg,
          })
          ..update(chatUserDocRef, {
            'lastMsgTime': newLastMessage.msgTime,
            'lastMsg': newLastMessage.msg,
            'unSeenMsgCount': FieldValue.increment(-unseenCountDecrement),
          });
      } else {
        updateBatch
          ..update(userChatDocRef, {'lastMsgTime': null, 'lastMsg': null})
          ..update(chatUserDocRef, {
            'lastMsgTime': null,
            'lastMsg': null,
            'unSeenMsgCount': FieldValue.increment(-unseenCountDecrement),
          });
      }

      await updateBatch.commit(); // ✅ Commit updates
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? '');
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      if (kDebugMode) {
        print('Exception: $e');
      }
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  Future<void> sendNotification({
    required String fcmToken,
    required String message,
    required String title,
    required Chat chat,
  }) async {
    debugPrint('sendNotification Method triggered');
    final serverAccessToken = await NotificationService.getServerAccessToken();

    debugPrint('chat from sendNotification : $chat');
    debugPrint('serverAccessToken : $serverAccessToken');
    debugPrint('fcmToken : $fcmToken');

    final body = {
      'message': {
        'token': fcmToken,
        'notification': {'title': title, 'body': message},
        'data': {
          'message': 'Sending message through push notification.',
          'route': RouteName.message,
          'chat': jsonEncode((chat as ChatModel).toMapLocal()),
        },
      },
    };

    final res = await _apiClient.post(
      url: ApiConfig.fcmSendUrl,
      body: body,
      serverAccessToken: serverAccessToken,
      needBaseUrl: false,
    );

    debugPrint('response from send notification : $res');
  }
}
