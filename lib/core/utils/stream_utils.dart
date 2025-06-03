import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/src/auth/data/models/local_user_model.dart';
import 'package:mustye/src/chat/data/model/chat_model.dart';
import 'package:mustye/src/contact/data/model/contact_model.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';
import 'package:mustye/src/message/data/model/message_model.dart';
import 'package:rxdart/rxdart.dart';

class StreamUtils {
  const StreamUtils._();

  static Stream<LocalUserModel> get getUserData {
    final firestore = sl<FirebaseFirestore>();
    final auth = sl<FirebaseAuth>();
    final uid = auth.currentUser!.uid;

    final userDocRef = firestore.collection('users').doc(uid);
    final chatsRef = userDocRef
        .collection('chats')
        .orderBy('lastMsgTime', descending: true);

    final userStream = userDocRef.snapshots();
    final chatsStream = chatsRef.snapshots();

    return Rx.combineLatest2(userStream, chatsStream, (
      DocumentSnapshot<Map<String, dynamic>> userSnap,
      QuerySnapshot<Map<String, dynamic>> chatsSnap,
    ) {
      final user = LocalUserModel.fromMap(userSnap.data()!);

      final chats =
          chatsSnap.docs.map((doc) => ChatModel.fromMap(doc.data())).toList();

      return user.copyWith(chats: chats);
    });
  }

  static Stream<List<Contact>> get getContacts => sl<FirebaseFirestore>()
      .collection('contacts')
      .where('uid', isNotEqualTo: sl<FirebaseAuth>().currentUser!.uid)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs
                .map((doc) => ContactModel.fromMap(doc.data()))
                .toList(),
      );

  static Stream<List<MessageModel>> getMessages(String chatId) {
    final user = sl<FirebaseAuth>().currentUser!;
    final currentUserId = user.uid;

    final ids = [currentUserId, chatId]..sort();
    final docId = ids.join('_');

    final firestore = sl<FirebaseFirestore>();

    final messages = firestore
        .collection('chats')
        .doc(docId)
        .collection('messages')
        .orderBy('msgTime', descending: false)
        .snapshots()
        .map((snapshot) {
          final batch = firestore.batch();
          final msgList =
              snapshot.docs.map((doc) {
                final message = MessageModel.fromMap(doc.data());

                if (message.recieverId == currentUserId && !message.isSeen) {
                  batch.update(doc.reference, {'isSeen': true});
                }

                return message;
              }).toList();

          batch.commit();

          return msgList;
        });

    return messages;
  }
}
