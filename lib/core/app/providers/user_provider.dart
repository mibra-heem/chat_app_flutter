import 'package:flutter/material.dart';
import 'package:mustye/src/auth/data/models/local_user_model.dart';

class UserProvider extends ChangeNotifier{

  LocalUserModel? _user;

  LocalUserModel? get user => _user;

  void initUser(LocalUserModel? user){
    if(_user != user) _user = user;
  }

  set user(LocalUserModel? user){
    if(_user != user){
      _user = user;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

}
