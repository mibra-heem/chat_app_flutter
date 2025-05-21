import 'package:flutter/cupertino.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    required this.initialRoute,
    required this.onGenerateRoute,
    required this.navigatorKey,
    super.key,

  });

  final String initialRoute;
  final GlobalKey<NavigatorState> navigatorKey;
  final Route<dynamic> Function(RouteSettings settings) onGenerateRoute;


  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: onGenerateRoute,
      onGenerateInitialRoutes: (_, __) {
        return [
          onGenerateRoute(RouteSettings(name: initialRoute)),
        ];
      },
    );
  }
}
