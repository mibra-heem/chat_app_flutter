import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mustye/core/app/providers/tab_navigator.dart';
import 'package:mustye/core/common/views/persistent_view.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/src/chat/presentation/cubit/chat_cubit.dart';
import 'package:mustye/src/chat/presentation/views/chat_view.dart';
import 'package:mustye/src/profile/presentation/views/profile_view.dart';
import 'package:provider/provider.dart';

class DashboardProvider extends ChangeNotifier {
  List<int> _indexHistory = [0];

  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create:
          (_) => TabNavigator(
            TabItem(
              child: BlocProvider(
                create: (context) => sl<ChatCubit>(),
                child: const ChatView(),
              ),
            ),
          ),
      child: const PersistentView(),
    ),
    // ChangeNotifierProvider(
    //   create: (_) => TabNavigator(TabItem(child: const Placeholder())),
    //   child: const PersistentView(),
    // ),
    // ChangeNotifierProvider(
    //   create: (_) => TabNavigator(TabItem(child: const Placeholder())),
    //   child: const PersistentView(),
    // ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(TabItem(child: const ProfileView())),
      child: const PersistentView(),
    ),
  ];

  List<Widget> get screens => _screens;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    _indexHistory.add(index);
    notifyListeners();
  }

  void goBack() {
    if (_indexHistory.length == 1) return;
    _indexHistory.removeLast();
    _currentIndex = _indexHistory.last;
    notifyListeners();
  }

  void resetIndex() {
    _indexHistory = [0];
    _currentIndex = 0;
    notifyListeners();
  }
}
