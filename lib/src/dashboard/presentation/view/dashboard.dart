import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/utils/stream_utils.dart';
import 'package:mustye/src/auth/domain/entities/local_user.dart';
import 'package:mustye/src/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const routeName = '/dashboard';

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
    final provider = Provider.of<DashboardProvider>(context);

    return PopScope(
      canPop: provider.canPop,
      onPopInvokedWithResult: (didPop, result) {
        debugPrint('On Pop Invoked From Dashboard');
      },

      child: StreamBuilder<LocalUser>(
        stream: StreamUtils.getUserData,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint('......... ${snapshot.connectionState.name} ..........');
          }
          if (snapshot.hasData && snapshot.data is LocalUser) {
            final userProvider = context.read<UserProvider>();
            if (userProvider.user != snapshot.data) {
              userProvider.cacheUserData(snapshot.data!);
            } else {
              debugPrint('....... No need to cache user data is same ........');
            }
          }
          if (snapshot.hasError) {
            debugPrint('Firestore error while Streaming: ${snapshot.error}');
          }
          return Consumer<DashboardProvider>(
            builder: (_, provider, __) {
              return Scaffold(
                body: IndexedStack(
                  index: provider.currentIndex,
                  children: provider.screens,
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: provider.currentIndex,
                  onTap: provider.changeIndex,
                  items: [
                    BottomNavigationBarItem(
                      label: 'Chat',
                      icon: Icon(
                        provider.currentIndex == 0
                            ? IconlyBold.paper
                            : IconlyLight.paper,
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: 'Profile',
                      icon: Icon(
                        provider.currentIndex == 1
                            ? IconlyBold.profile
                            : IconlyLight.profile,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
