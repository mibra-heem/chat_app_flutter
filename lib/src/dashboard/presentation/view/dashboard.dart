import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/utils/stream_utils.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('............ Dashboard .............');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        const tabBasePaths = ['/chat', '/profile'];

        if (didPop) return;
        final currentLocation = GoRouterState.of(context).uri.toString();
        final isNestedRoute = tabBasePaths.any(
          (basePath) =>
              currentLocation.startsWith(basePath) &&
              currentLocation != basePath,
        );

        if (isNestedRoute) {
          context.pop();
        } else if (widget.shell.currentIndex != 0) {
          widget.shell.goBranch(0);
        } else {
          SystemNavigator.pop();
        }
      },
      child: StreamBuilder<LocalUser>(
        stream: StreamUtils.getUserData,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint('......... ${snapshot.connectionState.name} ..........');
          }
          if (snapshot.hasData && snapshot.data is LocalUser) {
            debugPrint('....... snapshot.hasData ........');
            final userProvider = context.read<UserProvider>();
            if (userProvider.user != snapshot.data) {
              debugPrint('..... cacheUserData starting from Dashboard .......');
              userProvider.cacheUserData(snapshot.data!);
            } else {
              debugPrint('....... No need to cache user data is same ........');
            }
          }
          if (snapshot.hasError) {
            debugPrint('Firestore error while Streaming: ${snapshot.error}');
          }
          return Scaffold(
            body: widget.shell,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: widget.shell.currentIndex,
              onTap: widget.shell.goBranch,
              items: [
                BottomNavigationBarItem(
                  label: 'Chat',
                  icon: Icon(
                    widget.shell.currentIndex == 0
                        ? IconlyBold.paper
                        : IconlyLight.paper,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Profile',
                  icon: Icon(
                    widget.shell.currentIndex == 1
                        ? IconlyBold.profile
                        : IconlyLight.profile,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
