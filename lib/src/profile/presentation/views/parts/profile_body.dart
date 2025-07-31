import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/app/widgets/my_dialog_box.dart';
import 'package:mustye/core/config/route_config.dart';
import 'package:mustye/core/enums/themes.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/extensions/string_extention.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/src/profile/features/theme/presentation/provider/theme_provider.dart';
import 'package:mustye/src/profile/presentation/views/widgets/user_profile_tile.dart';
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
            UserProfileTile(
              title: 'Edit Profile',
              icon: IconlyLight.edit_square,
              iconColor: Colors.cyan,
              onTap: () => context.pushNamed(RouteName.editProfile),
            ),
            const UserProfileTile(
              title: 'Favourites',
              icon: IconlyLight.heart,
              iconColor: Colors.amber,
              // onTap: () => context.pushNamed(RouteName.favourite),
            ),
            UserProfileTile(
              title: 'Theme',
              icon: IconlyLight.filter,
              iconColor: Colors.lightBlue,
              onTap: () {
                showDialog<Navigator>(
                  context: context,
                  builder: (_) {
                    return Dialog(
                      child: SizedBox(
                        width: context.width * 0.75,
                        child: Consumer<ThemeProvider>(
                          builder: (_, controller, __) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Radio<Themes>(
                                      value: Themes.values[index],
                                      groupValue:
                                          Themes.values[controller
                                              .themeMode
                                              .index],
                                      onChanged: (v) {
                                        if (v != null) controller.setTheme(v);
                                      },
                                    ),
                                    Text(
                                      ThemeMode
                                          .values[index]
                                          .name
                                          .firstLetterCapital,
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const UserProfileTile(
              title: 'Privacy',
              icon: IconlyLight.shield_done,
              iconColor: Colors.lightGreen,
              // onTap: () => context.pushNamed(RouteName.privacy),
            ),
            UserProfileTile(
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
