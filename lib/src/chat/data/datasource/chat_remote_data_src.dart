import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/utils/datasource_utils.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';

abstract class ChatRemoteDataSrc {
  const ChatRemoteDataSrc();

  Future<void> deleteChat(Chat chat);
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
  Future<void> deleteChat(Chat chat) async {
    try {
      await DatasourceUtils.authorizeUser(_auth);

      if (kDebugMode) {
        print('..... Current User while add Chat ${_auth.currentUser}');
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
  Future<void> messageSeen({required String senderUid}) async {
    try {
      await DatasourceUtils.authorizeUser(_auth);

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('chats')
          .doc(senderUid)
          .update({'isMsgSeen': true, 'unSeenMsgCount': 0});
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
