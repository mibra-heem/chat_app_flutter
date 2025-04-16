import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/utils/datasource_utils.dart';
import 'package:mustye/src/contact/data/model/contact_model.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';

abstract class ChatRemoteDataSrc {
  const ChatRemoteDataSrc();

  Future<List<Contact>> getChats();
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
  Future<List<Contact>> getChats() async {
    try {
      await DatasourceUtils.authorizeUser(_auth);

      if(kDebugMode){
        print('..... Current User while add Chat ${_auth.currentUser}');
      }

      // return [Contact.empty()];
      
      return await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('chats')
        .get()
        .then((value) => value.docs.map(
          (m)=> ContactModel.fromMap(m.data()),
        ).toList(),);
        
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
