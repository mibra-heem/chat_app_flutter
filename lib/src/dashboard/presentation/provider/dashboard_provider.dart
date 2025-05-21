import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mustye/core/constants/route_const.dart';
import 'package:mustye/core/services/on_generate_route.dart';
import 'package:mustye/src/dashboard/presentation/view/tab_navigator.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardProvider({required List<GlobalKey<NavigatorState>> tabKeys})
    : _tabKeys = tabKeys;

  final List<GlobalKey<NavigatorState>> _tabKeys;

  List<GlobalKey<NavigatorState>> get tabKeys => _tabKeys;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    notifyListeners();
  }

  // List<Widget> get screens => <TabNavigator>[
  //   TabNavigator(
  //     initialRoute: RouteConst.chat,
  //     navigatorKey: _tabKeys[0],
  //     onGenerateRoute: RouteGenerator.onGenerateRouteChatTab,
  //   ),
  //   TabNavigator(
  //     initialRoute: RouteConst.profile,
  //     navigatorKey: _tabKeys[1],
  //     onGenerateRoute: RouteGenerator.onGenerateRouteProfileTab,
  //   ),
  // ];

  void onPopInvokedWithResult(_, __) {
    final currentState = _tabKeys[currentIndex].currentState;

    if (currentState!.canPop() == true) {
      currentState.pop();
    } else {
      if (_currentIndex != 0) {
        currentIndex = 0;
        debugPrint('Switched to home tab (index 0)');
      } else {
        SystemNavigator.pop();
      }
    }
  }
}
