import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mustye/core/app/providers/tab_navigator.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/setting/presentation/provider/setting_provider.dart';

extension ContextExtension on BuildContext{
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get size => mediaQuery.size;
  double get height => size.height;
  double get width => size.width;

  UserProvider get userProvider => read<UserProvider>();

  LocalUser? get currentUser => userProvider.user;

  SettingProvider get settingProvider => read<SettingProvider>();

  TabNavigator get tabNavigator => read<TabNavigator>();

  void pop () => tabNavigator.pop(); 

  void push(Widget page) => tabNavigator.push(TabItem(child: page));
}
