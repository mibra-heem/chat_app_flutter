import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/res/colors.dart';
import 'package:mustye/src/auth/data/models/local_user_model.dart';
import 'package:mustye/src/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:mustye/src/dashboard/presentation/utils/dashboard_utils.dart';
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
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<LocalUserModel>(
      stream: DashboardUtils.userDataStream,
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data is LocalUserModel) {
          context.userProvider.user = snapshot.data;

        }
        if(kDebugMode) print('............ User Streaming  ............');
        return Consumer<DashboardProvider>(
            builder: (_, provider, __) {
              return Scaffold(
                body: IndexedStack(
                  index: provider.currentIndex,
                  children: provider.screens,
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: provider.currentIndex,
                  selectedItemColor: Colours.primaryColor,
                  backgroundColor: Colors.white,
                  elevation: 8,
                  onTap: provider.changeIndex,
                  items: [
                    BottomNavigationBarItem(
                      label: 'Chat',
                      backgroundColor: Colors.white,
                      icon: Icon(
                        provider.currentIndex == 0 
                        ? IconlyBold.paper 
                        : IconlyLight.paper,
                        color: provider.currentIndex == 0 
                        ? Colours.primaryColor
                        : Colors.grey,
                      ),
                    ),
                    // BottomNavigationBarItem(
                    //   label: 'Material',
                    //   backgroundColor: Colors.white,
                    //   icon: Icon(
                    //     provider.currentIndex == 1
                    //     ? IconlyBold.document 
                    //     : IconlyLight.document,
                    //     color: provider.currentIndex == 1
                    //     ? Colours.primaryColor
                    //     : Colors.grey,
                    //   ),
                    // ),
                    // BottomNavigationBarItem(
                    //   label: 'Chat',
                    //   backgroundColor: Colors.white,
                    //   icon: Icon(
                    //     provider.currentIndex == 2
                    //     ? IconlyBold.chat 
                    //     : IconlyLight.chat,
                    //     color: provider.currentIndex == 2
                    //     ? Colours.primaryColor
                    //     : Colors.grey,
                    //   ),
                    // ),
                    BottomNavigationBarItem(
                      label: 'Profile',
                      backgroundColor: Colors.white,
                      icon: Icon(
                        provider.currentIndex == 1 
                        ? IconlyBold.profile 
                        : IconlyLight.profile,
                        color: provider.currentIndex == 1 
                        ? Colours.primaryColor
                        : Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
        );
      },
    );
  }
}
