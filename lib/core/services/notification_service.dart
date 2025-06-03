import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/constants/api_const.dart';
import 'package:mustye/core/constants/route_const.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/core/services/go_router.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/chat/data/model/chat_model.dart';

class NotificationService {
  const NotificationService._();

  /// Request push notification permission from user
  static Future<void> requestPermission(FirebaseMessaging instance) async {
    final settings = await instance.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Permission is authorized.');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('Permission is provisional.');
    } else {
      debugPrint('Permission denied.');
    }
  }

  /// Initialize FCM message listeners
  static Future<void> initFirebaseNotificationListerners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('From message listen: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint('From onMessageOpenedApp listen: $message');
      final route = message.data['route'];
      final chatJson = jsonDecode(message.data['chat'] as String) as DataMap;
      final chat = ChatModel.fromMap(chatJson);

      if (route == RouteName.message) {
        await router.pushNamed(RouteName.message, extra: chat);
      }
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('initialMessage is not null.');
      await handleMessage(initialMessage);
    }

    FirebaseMessaging.onBackgroundMessage(handleMessage);
  }

  /// Handle background messages
  @pragma('vm:entry-point')
  static Future<void> handleMessage(RemoteMessage message) async {
    debugPrint('From handle message: ${message.messageId}');
  }

  /// Initializes and syncs the FCM token
  static Future<void> initFcmToken() async {
    final messaging = FirebaseMessaging.instance;
    final auth = sl<FirebaseAuth>();
    final user = sl<UserProvider>().user;

    if (auth.currentUser != null && user != null) {
      // Sync token with Firestore
      await updateFcmToken(auth: auth, user: user);
    }

    // Listen for token refresh
    messaging.onTokenRefresh.listen((newToken) async {
      if (auth.currentUser != null) {
        await sl<FirebaseFirestore>()
            .collection('users')
            .doc(auth.currentUser!.uid)
            .update({'fcmToken': newToken});
      }
    });
  }

  /// Syncs token with Firestore if it has changed
  static Future<void> updateFcmToken({
    required FirebaseAuth auth,
    required LocalUser? user,
  }) async {
    final firestore = sl<FirebaseFirestore>();
    final existingToken = user!.fcmToken;
    final fcmToken = sl<String>(instanceName: ApiConst.fcmToken) as String?;

    debugPrint('Existing Token: $existingToken');
    debugPrint('Current Token: $fcmToken');
    if (fcmToken != null) {
      if (existingToken != fcmToken) {
        debugPrint('Updating FCM token in Firestore...');
        await firestore.collection('users').doc(user.uid).update({
          'fcmToken': fcmToken,
        });
      }
    }
  }

  /// For server-to-device notification sending
  static Future<String> getServerAccessToken() async {
    final http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(ApiConst.serviceAccountJson),
      ApiConst.scopes,
    );

    final credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(ApiConst.serviceAccountJson),
      ApiConst.scopes,
      client,
    );

    client.close();
    return credentials.accessToken.data;
  }
}
