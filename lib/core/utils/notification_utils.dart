import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:mustye/core/constants/api_const.dart';

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
}
