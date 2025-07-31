import 'package:flutter/material.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/chat/presentation/provider/chat_provider.dart';
import 'package:mustye/src/message/presentation/provider/message_provider.dart';
import 'package:provider/provider.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get color => theme.colorScheme;
  TextTheme get text => theme.textTheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get size => mediaQuery.size;
  double get height => size.height;
  double get width => size.width;

  UserProvider get userProvider => read<UserProvider>();
  LocalUser? get currentUser => userProvider.user;

  ChatProvider get chatProvider => read<ChatProvider>();

  MessageProvider get messageProvider => read<MessageProvider>();


}
