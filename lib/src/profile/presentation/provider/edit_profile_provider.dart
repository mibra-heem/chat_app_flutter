import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mustye/core/utils/core_utils.dart';

class EditProfileProvider extends ChangeNotifier {
  File? pickedImage;
  bool get imageChanged => pickedImage != null;

  Future<void> pickImage() async {
    pickedImage = await CoreUtils.pickImage();
    notifyListeners();
  }
}
