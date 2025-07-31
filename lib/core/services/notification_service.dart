import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/config/api_config.dart';
import 'package:mustye/core/config/route_config.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/core/services/go_router.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/chat/data/model/chat_model.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint('From handle background message: ${message.messageId}');
  // await NotificationService._handleMessageNavigation(message);
}

// @pragma('vm:entry-point')
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
  static Future<void> initFirebaseNotificationListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('From onMessage listen: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint('From onMessageOpenedApp listen: $message');
      await _handleMessageNavigation(message);
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  static void handleInitialMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();

      if (initialMessage != null) {
        debugPrint('initialMessage is not null.');
        debugPrint('And initialMessage is ${initialMessage.data}');

        final route = initialMessage.data['route'] as String?;
        if (route == RouteName.message) {
          debugPrint('Go to the message screen ......');

          await router.pushNamed(RouteName.message);
        }
      }
    });
  }

  static Future<void> _handleMessageNavigation(RemoteMessage message) async {
    debugPrint('From handle message navigation: ${message.messageId}');

    try {
      if (message.data.isEmpty ||
          !message.data.containsKey('route') ||
          !message.data.containsKey('chat')) {
        debugPrint('Invalid message data: $message');
        return;
      }

      final route = message.data['route'] as String?;
      final chatJson = message.data['chat'] as String?;

      if (route == null || chatJson == null) {
        debugPrint(
          'Route or chat data is null: route=$route, chatJson=$chatJson',
        );
        return;
      }

      final chatMap = jsonDecode(chatJson) as Map<String, dynamic>;
      final chat = ChatModel.fromMap(chatMap);

      if (route == RouteName.message) {
        final context = router.routerDelegate.navigatorKey.currentContext;
        if (context != null) {
          await router.pushNamed(RouteName.message, extra: chat);
        } else {
          debugPrint(
            'Navigation context is null. Storing chat for later navigation.',
          );
        }
      }
    } on Exception catch (e, stackTrace) {
      debugPrint('Error in handleMessageNavigation: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Set and syncs the FCM token in firestore
  static Future<void> setFcmToken() async {
    final messaging = FirebaseMessaging.instance;
    final auth = sl<FirebaseAuth>();
    final user = sl<UserProvider>().user;

    if (auth.currentUser != null && user != null) {
      await updateFcmToken(auth: auth, user: user);
    }

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
    final fcmToken = sl<String>(instanceName: ApiConfig.fcmToken) as String?;

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
      auth.ServiceAccountCredentials.fromJson(ApiConfig.serviceAccountJson),
      ApiConfig.scopes,
    );

    final credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(ApiConfig.serviceAccountJson),
      ApiConfig.scopes,
      client,
    );

    client.close();
    return credentials.accessToken.data;
  }
}
