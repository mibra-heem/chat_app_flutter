import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/common/widgets/my_dialog_box.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:mustye/src/profile/presentation/provider/edit_profile_provider.dart';
import 'package:mustye/src/profile/presentation/views/edit_profile_view.dart';
import 'package:mustye/src/profile/presentation/views/widgets/user_profile_card.dart';
import 'package:mustye/src/setting/presentation/views/setting_view.dart';
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
              onTap:
                  () => context.push(
                    BlocProvider(
                      create: (context) => sl<AuthBloc>(),
                      child: ChangeNotifierProvider(
                        create: (_) => ProfileProvider(),
                        child: const EditProfileView(),
                      ),
                    ),
                  ),
            ),
            UserProfileCard(
              title: 'Notification',
              icon: IconlyLight.notification,
              iconColor: Colors.lightGreen,
              onTap:
                  () => context.push(
                    const Center(child: Text('Notifications Page')),
                  ),
            ),
            UserProfileCard(
              title: 'Setting',
              icon: IconlyLight.setting,
              iconColor: Colors.lightBlue,
              onTap: () => context.push(const SettingView()),
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
                        final navigator = Navigator.of(context);
                        await sl<FirebaseAuth>().signOut();
                        await sl<GoogleSignIn>().signOut();
                        unawaited(
                          navigator.pushNamedAndRemoveUntil(
                            '/',
                            (route) => false,
                          ),
                        );
                      },
                      // onCancel: (){

                      // },
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
