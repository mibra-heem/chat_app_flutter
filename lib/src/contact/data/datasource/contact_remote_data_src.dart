import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/utils/datasource_utils.dart';
import 'package:mustye/src/auth/data/models/local_user_model.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';

abstract class ContactRemoteDataSrc {
  const ContactRemoteDataSrc();

  Future<List<LocalUser>> getContacts();
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
  Future<List<LocalUser>> getContacts() async {
    try {
      await DatasourceUtils.authorizeUser(_auth);

      if(kDebugMode){
        print('..... Current User while getting Contacts ${_auth.currentUser}');
      }

      return _firestore
          .collection('users')
          .where('uid', isNotEqualTo: _auth.currentUser!.uid)
          .get()
          .then(
            (value) =>
                value.docs
                    .map((doc) => LocalUserModel.fromMap(doc.data()))
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
}
