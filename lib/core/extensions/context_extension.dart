import 'package:flutter/material.dart';

extension ContextExtension on BuildContext{
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get size => mediaQuery.size;
  double get height => size.height;
  double get width => size.width;

  // UserProvider get userProvider => read<UserProvider>();

  // UserEntity? get currentUser => userProvider.user;

  // TabNavigator get tabNavigator => read<TabNavigator>();

//   void pop () => tabNavigator.pop(); 

//   void push(Widget page) => tabNavigator.push(TabItem(child: page));
}
