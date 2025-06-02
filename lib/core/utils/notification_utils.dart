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
import 'package:mustye/core/services/router.dart';
import 'package:mustye/core/utils/typedef.dart';
import 'package:mustye/src/chat/data/model/chat_model.dart';

class NotificationUtils {
  const NotificationUtils._();

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

  static Future<String> getServerAccessToken() async {
    final http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(ApiConst.serviceAccountJson),
      ApiConst.scopes,
    );

    final crendentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(ApiConst.serviceAccountJson),
      ApiConst.scopes,
      client,
    );

    client.close();

    return crendentials.accessToken.data;
  }

  static Future<void> initFirebaseNotificationListerners() async{
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('From message listen');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint('From onMessageOpenedApp listen message : $message');
      final route = message.data['route'];
      final chatJson = jsonDecode(message.data['chat'] as String) as DataMap;
      final chat = ChatModel.fromMap(chatJson);

      if (route == RouteName.message) {
        await router.pushNamed(RouteName.message, extra: chat);
      }
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null){
      debugPrint('initialMessage is not null.');

      await handleMessage(initialMessage);
    }

    FirebaseMessaging.onBackgroundMessage(handleMessage);
  }

  @pragma('vm:entry-point')
  static Future<void> handleMessage(RemoteMessage message)async{
    debugPrint('From handle message');
  }

  static Future<void> initFcmToken() async {
    final messaging = sl<FirebaseMessaging>();
    final auth = sl<FirebaseAuth>();
    final firestore = sl<FirebaseFirestore>();
    final user = sl<UserProvider>().user;

    // Update Device Token Only If Current Token Does Not Match
    if (auth.currentUser != null) {
      debugPrint('auth.currentUser is not null ');

      final token = await messaging.getToken();
      if (token != null && user != null) {
        final existingToken = user.fcmToken;
        debugPrint('existingToken : $existingToken');
        debugPrint('from getToken() : $token');

        if (existingToken != token) {
          debugPrint('Updating the existing token');

          await firestore.collection('users').doc(auth.currentUser!.uid).update(
            {'fcmToken': token},
          );
        }
      }
    }

    // Update Device Token on refresh listener
    messaging.onTokenRefresh.listen((newToken) {
      if (auth.currentUser != null) {
        firestore.collection('users').doc(auth.currentUser!.uid).update({
          'fcmToken': newToken,
        });
      }
    });
  }
}
