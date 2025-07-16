import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/utils/datasource_utils.dart';
import 'package:mustye/src/message/features/call/audio/data/models/incoming_audio_call_model.dart';
import 'package:mustye/src/message/features/call/audio/domain/entities/incoming_audio_call.dart';

abstract class AudioCallRemoteDataSrc {
  const AudioCallRemoteDataSrc();
  Future<void> activateIncomingAudioCall(AudioCall call);
  Future<void> acceptAudioCall(AudioCall call);
  Future<void> rejectAudioCall(AudioCall call);
  Future<void> cancelAudioCall(AudioCall call);
  Future<void> endAudioCall(AudioCall call);
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
  Future<void> activateIncomingAudioCall(AudioCall call) async {
    try {
      // Authorizing the user
      DatasourceUtils.authorizeUser(_auth);

      // Set incomingAudioCall document in firestore
      await _firestore
          .collection('calls')
          .doc(call.uid)
          .set((call as AudioCallModel).toMap());
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
  Future<void> acceptAudioCall(AudioCall call) async {
    try {
      // Authorizing the user
      DatasourceUtils.authorizeUser(_auth);

      // Accept the call
      await FirebaseFirestore.instance
          .collection('calls')
          .doc(call.uid)
          .update((call as AudioCallModel).toMap());
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? '');
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 'accept-audio-call',
      );
    }
  }

  @override
  Future<void> rejectAudioCall(AudioCall call) async {
    try {
      // Authorizing the user
      DatasourceUtils.authorizeUser(_auth);

      // Reject the call
      await FirebaseFirestore.instance
          .collection('calls')
          .doc(call.uid)
          .update((call as AudioCallModel).toMap());
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? '');
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 'reject-audio-call',
      );
    }
  }

  @override
  Future<void> endAudioCall(AudioCall call) async {
    try {
      // Authorizing the user
      DatasourceUtils.authorizeUser(_auth);

      // End the call
      await FirebaseFirestore.instance
          .collection('calls')
          .doc(call.uid)
          .update((call as AudioCallModel).toMap());
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? '');
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 'end-audio-call',
      );
    }
  }

  @override
  Future<void> cancelAudioCall(AudioCall call) async {
    try {
      // Authorizing the user
      DatasourceUtils.authorizeUser(_auth);

      // End the call
      await FirebaseFirestore.instance
          .collection('calls')
          .doc(call.uid)
          .update((call as AudioCallModel).toMap());
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? '');
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 'cacnel-audio-call',
      );
    }
  }
}
