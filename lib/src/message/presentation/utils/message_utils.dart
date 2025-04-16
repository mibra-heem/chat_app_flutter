import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/src/message/data/model/message_model.dart';
import 'package:mustye/src/message/domain/entity/message.dart';

class MessageUtils {
  const MessageUtils._();

  static Stream<List<Message>> getMessages(String recieverId) {
    final user = sl<FirebaseAuth>().currentUser!;

    final ids = [user.uid, recieverId]..sort();
    final docId = ids.join('_');

    if(kDebugMode) print('Error is here while getting messages......');

    return sl<FirebaseFirestore>()
        .collection('chats')
        .doc(docId)
        .collection('messages')
        .orderBy('msgTime', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(
                (doc) => MessageModel.fromMap(doc.data()),
              ).toList(),
        );
  }
}
