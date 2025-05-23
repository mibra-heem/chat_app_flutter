import 'package:flutter/material.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/profile/features/theme/presentation/controller/theme_controller.dart';
import 'package:provider/provider.dart';

extension ContextExtension on BuildContext{
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get size => mediaQuery.size;
  double get height => size.height;
  double get width => size.width;

  UserProvider get userProvider => read<UserProvider>();

  LocalUser? get currentUser => userProvider.user;

  ThemeController get themeController => read<ThemeController>();

}
