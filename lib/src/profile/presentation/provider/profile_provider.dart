import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mustye/core/utils/core_utils.dart';

class ProfileProvider extends ChangeNotifier {

  File? pickedImage;
  bool get imageChanged => pickedImage != null;

  Future<void> pickImage() async {
    pickedImage = await CoreUtils.pickImage();
    notifyListeners();
  }
}
