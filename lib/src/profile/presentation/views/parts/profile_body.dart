import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/common/widgets/my_dialog_box.dart';
import 'package:mustye/core/constants/route_const.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/src/profile/presentation/views/widgets/user_profile_card.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            UserProfileCard(
              title: 'Edit Profile',
              icon: IconlyLight.edit_square,
              iconColor: Colors.amber,
              onTap: () => context.pushNamed(RouteName.editProfile),
            ),
            UserProfileCard(
              title: 'Notification',
              icon: IconlyLight.notification,
              iconColor: Colors.lightGreen,
              onTap: () => context.pushNamed(RouteName.notification),
            ),
            UserProfileCard(
              title: 'Setting',
              icon: IconlyLight.setting,
              iconColor: Colors.lightBlue,
              onTap: () => context.pushNamed(RouteName.setting),
            ),
            UserProfileCard(
              title: 'Logout',
              icon: IconlyLight.logout,
              iconColor: Colors.red,
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (_) {
                    return AppDialogBox.alert(
                      title: 'Logout',
                      content: 'You want to logout from this account.',
                      onConfirm: () async {
                        context.goNamed(RouteName.signIn);
                        await sl<FirebaseAuth>().signOut();
                        await sl<GoogleSignIn>().signOut();
                        debugPrint('Check if it is even coming here or not?');
                      },
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
