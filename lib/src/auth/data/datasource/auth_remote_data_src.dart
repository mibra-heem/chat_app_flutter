import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mustye/core/constants/constants.dart';
import 'package:mustye/core/enums/update_user_action.dart';
import 'package:mustye/core/errors/exception.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/data/models/local_user_model.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/chat/data/model/chat_model.dart';
import 'package:mustye/src/contact/data/model/contact_model.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<void> forgotPassword(String email);
  Future<LocalUser> googleSignIn();
  Future<LocalUser> signIn({required String email, required String password});
  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });
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
    required GoogleSignIn googleSignIn,
  }) : _authClient = authClient,
       _firestore = firestore,
       _dbClient = dbClient,
       _googleSignIn = googleSignIn;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _dbClient;
  final GoogleSignIn _googleSignIn;

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _authClient.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? '');
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<LocalUser> googleSignIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknown',
        );
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _authClient.signInWithCredential(credential);

      if (kDebugMode) {
        print('........ User Object : ${userCredential.user} ......');
        print('..... User Name : ${userCredential.user!.displayName} .......');
        print('..... User Email : ${userCredential.user!.email} .......');
        print('..... User PhotoURL : ${userCredential.user!.photoURL} .......');
      }

      return await getLocalUserModel(userCredential);
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
  Future<LocalUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = await _authClient.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return await getLocalUserModel(credentials);
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
  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      final createUser = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (kDebugMode) {
        print('DEBUG: Firebase Auth response -> $createUser');

        if (createUser is List<Object?>) {
          print('Error: Received List<Object?> instead of expected type.');
        }
      }

      await createUser.user?.updateDisplayName(fullName);
      await createUser.user?.updatePhotoURL(kDefaultAvatar);
      await _setUserData(_authClient.currentUser!, email);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('The Exception From FirebaseAuth : ${e.message}');
      throw ServerException(
        message: e.message ?? 'Error Occupied',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      if (kDebugMode) print('Unkown Exception Occurred is : $e');
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

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
    final user = credentials.user;

    if (user == null) {
      throw const ServerException(
        message: 'Please try again later',
        statusCode: 'Unknown',
      );
    }

    // Helper to fetch and build the LocalUserModel
    Future<LocalUser> buildUserModel() async {
      final userData = await _getUserData(user.uid);
      final chats = await _getChatsData(user.uid);

      final chatsModel = chats.docs
                  .map((doc) => ChatModel.fromMap(doc.data()))
                  .toList();      

      final lastUser = LocalUserModel.fromMap(
        userData.data()!,
      ).copyWith(chats: chatsModel);

      if (kDebugMode) print('..... CopyWith User :  $lastUser');

      return lastUser;
    }

    final userData = await _getUserData(user.uid);
    final chats = await _getChatsData(user.uid);

    if (userData.exists && chats.docs.isNotEmpty) {
      return buildUserModel();
    }

    await _setUserData(user, user.email!);

    return buildUserModel();
  }

  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) async {
    return _firestore.collection('users').doc(uid).get();
  }

  Future<QuerySnapshot<DataMap>> _getChatsData(String uid) async {
    return _firestore.collection('users').doc(uid).collection('chats').get();
  }

  Future<void> _setUserData(User user, String fallbackEmail) async {
    final localUser = LocalUserModel(
      uid: user.uid,
      email: user.email ?? fallbackEmail,
      name: user.displayName ?? '',
      image: user.photoURL ?? '',
    );

    final contact = ContactModel(
      uid: user.uid,
      email: user.email ?? fallbackEmail,
      name: user.displayName ?? '',
      image: user.photoURL ?? '',
    );

    await _firestore.collection('users').doc(user.uid).set(localUser.toMap());

    await _firestore.collection('contacts').doc(user.uid).set(contact.toMap());
  }

  Future<void> _updateUserData(DataMap userData) async {
    final currentUser = _authClient.currentUser!;

    debugPrint('User Data updating method : $userData');


    // 1. Update current user's own document
    await _firestore.collection('users').doc(currentUser.uid).update(userData);

    // 2. Optionally update the 'contacts' collection if you're using it
    await _firestore
        .collection('contacts')
        .doc(currentUser.uid)
        .update(userData);

    // 3. Fetch all users to find contacts referencing the current user
    final users = await _firestore.collection('users').get();

    for (final doc in users.docs) {
      debugPrint('Entered Into Loop .......');

      final chatsCollection = doc.reference.collection('chats');
      final chatDoc = chatsCollection.doc(currentUser.uid);
      final snapshot = await chatDoc.get();

      debugPrint('Snapshot exists : ${snapshot.exists} .......');
      debugPrint('Chat Collection Id : ${chatsCollection.doc()} .......');

      if (snapshot.exists) {
        debugPrint('Snapshot exists ........ updating chats .......');
        await chatDoc.update(userData);
      }
    }
  }
}
