import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:mustye/core/config/api_config.dart';
import 'package:mustye/core/enums/update_user_action.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/core/services/notification_service.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/data/models/local_user_model.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/chat/data/model/chat_model.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<String> phoneAuthentication(String phone);
  Future<void> verifyOTP(String otp);
  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
}

class AuthRemoteDataSrcImpl extends AuthRemoteDataSource {
  const AuthRemoteDataSrcImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore firestore,
    required FirebaseStorage dbClient,
  }) : _authClient = authClient,
       _firestore = firestore,
       _dbClient = dbClient;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _dbClient;

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  }) async {
    try {
      final user = _authClient.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'User is not authenticated.',
          statusCode: '401',
        );
      }

      switch (action) {
        case UpdateUserAction.displayName:
          await user.updateDisplayName(userData as String);
          return await _updateUserData({'name': userData});

        case UpdateUserAction.email:
          await user.verifyBeforeUpdateEmail(userData as String);
          return await _updateUserData({'email': userData});

        case UpdateUserAction.image:
          final userId = user.uid;
          final imageFile = userData as File;
          final ref = _dbClient.ref().child('profile_pictures/$userId');

          // Upload file & get URL
          final uploadTask = ref.putFile(imageFile);
          final snapshot = await uploadTask.whenComplete(() => {});
          final imageURL = await snapshot.ref.getDownloadURL();

          // Update user profile and database
          await user.updatePhotoURL(imageURL);
          return await _updateUserData({'imageURL': imageURL});

        case UpdateUserAction.password:
          if (user.email == null) {
            throw const ServerException(
              message: 'User does not exist.',
              statusCode: '403',
            );
          }
          final data = jsonDecode(userData as String) as Map<String, dynamic>;
          await user.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: user.email!,
              password: data['oldPassword'] as String,
            ),
          );
          await user.updatePassword(data['newPassword'] as String);
          return;

        case UpdateUserAction.bio:
          return await _updateUserData({'bio': userData});
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'An authentication error occurred',
        statusCode: e.code,
      );
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'A Firebase error occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint('Unexpected error in updateUser: $e');
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }

  Future<LocalUser> getLocalUserModel(UserCredential credentials) async {
    final firebaseUser = credentials.user;

    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'user-credentials-is-null',
        message: 'Please try again later',
      );
    }

    // Step 1: Fetch existing data
    var userDocSnapshot = await _getUserData(firebaseUser.uid);
    var chatsQuerySnapshot = await _getChatsData(firebaseUser.uid);

    // Step 2: If user doesn't exist or has no chats
    if (!userDocSnapshot.exists || chatsQuerySnapshot.docs.isEmpty) {
      debugPrint(
        '........ Data does not exits in firestore yet, so setting it and '
        're-fetching the user & chats data ........',
      );
      print('Phone Number => ${firebaseUser.phoneNumber}');
      await _setUserData(
        firebaseUser,
        firebaseUser.phoneNumber ?? '03334382219',
      );
      // Refetching user and chats after setting new data
      userDocSnapshot = await _getUserData(firebaseUser.uid);
      chatsQuerySnapshot = await _getChatsData(firebaseUser.uid);
    }

    // Step 3: Parse chat models
    final chatsModel =
        chatsQuerySnapshot.docs
            .map((doc) => ChatModel.fromMap(doc.data()))
            .toList();

    // Step 4: Build local user model
    final localUser = LocalUserModel.fromMap(
      userDocSnapshot.data()!,
    ).copyWith(chats: chatsModel);

    debugPrint('..... User When sign In: $localUser');

    // Step 5: Update FCM token
    await NotificationService.updateFcmToken(
      auth: _authClient,
      user: localUser,
    );

    return localUser;
  }

  Future<DocumentSnapshot<SDMap>> _getUserData(String uid) async {
    return _firestore.collection('users').doc(uid).get();
  }

  Future<QuerySnapshot<SDMap>> _getChatsData(String uid) async {
    return _firestore.collection('users').doc(uid).collection('chats').get();
  }

  Future<void> _setUserData(User user, String fallbackPhone) async {
    final fcmToken = sl<String>(instanceName: ApiConfig.fcmToken) as String?;

    final localUser = LocalUserModel(
      uid: user.uid,
      phone: user.phoneNumber ?? fallbackPhone,
      name: user.displayName ?? '',
      avatar: user.photoURL ?? '',
      fcmToken: fcmToken,
    );

    await _firestore.collection('users').doc(user.uid).set(localUser.toMap());
  }

  Future<void> _updateUserData(SDMap userData) async {
    final currentUser = _authClient.currentUser!;

    // Update current user's data in users collection
    await _firestore.collection('users').doc(currentUser.uid).update(userData);

    // Fetch all users to find contacts referencing the current user
    final users = await _firestore.collection('users').get();

    for (final doc in users.docs) {
      final chatsCollection = doc.reference.collection('chats');
      final chatDoc = chatsCollection.doc(currentUser.uid);
      final snapshot = await chatDoc.get();
      if (snapshot.exists) {
        await chatDoc.update(userData);
      }
    }
  }

  @override
  Future<String> phoneAuthentication(String phone) async {
    try {
      await _authClient.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          debugPrint('Verification failed: ${e.message}');
          throw FirebaseException(
            plugin: e.message ?? 'No Error Message Found.',
          );
        },
        codeSent: (id, token) {},
        codeAutoRetrievalTimeout: (id) {},
      );

      return '';
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
  Future<void> verifyOTP(String otp) async {
    try {
      // final googleUser = await _googleSignIn.signIn();

      // final googleAuth = await googleUser.authentication;

      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.idToken,
      // );

      // await _authClient.signInWithCredential(credential);
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
