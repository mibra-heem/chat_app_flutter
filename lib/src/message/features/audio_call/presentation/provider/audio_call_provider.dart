import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioCallProvider extends ChangeNotifier{
  
  AudioCallProvider();
  int? remoteUid;

  // Requests microphone permission
  static Future<void> requestPermissions() async {
    await [Permission.microphone].request();
  }

}
