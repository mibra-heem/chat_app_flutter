import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/utils/datasource_utils.dart';
import 'package:mustye/src/message/features/call/audio/data/models/incoming_audio_call_model.dart';
import 'package:mustye/src/message/features/call/audio/domain/entities/incoming_audio_call.dart';

abstract class AudioCallRemoteDataSrc {
  const AudioCallRemoteDataSrc();
  Future<void> activateIncomingAudioCall(IncomingAudioCall call);
  Future<void> deactivateIncomingAudioCall();

}

class AudioCallRemoteDataSrcImpl implements AudioCallRemoteDataSrc {
  const AudioCallRemoteDataSrcImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Future<void> activateIncomingAudioCall(IncomingAudioCall call) async {
    try {
      // Authorizing the user
      DatasourceUtils.authorizeUser(_auth);

      // Set incomingAudioCall document in firestore
      await _firestore
          .collection('incoming_audio_calls')
          .doc(call.receiverId)
          .set((call as IncomingAudioCallModel).toMap());
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? '');
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 'activate-incoming-audio-call',
      );
    }
  }

    @override
  Future<void> deactivateIncomingAudioCall() async {
    try {
      // Authorizing the user
      DatasourceUtils.authorizeUser(_auth);

      debugPrint('Going to delete the document..............');
      // Delete incomingAudioCall document in firestore
      await _firestore
          .collection('incoming_audio_calls')
          .doc(_auth.currentUser!.uid)
          .delete();
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? '');
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 'deactivate-incoming-audio-call',
      );
    }
  }
}
