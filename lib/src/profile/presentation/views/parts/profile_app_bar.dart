import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mustye/core/common/widgets/popup_item.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:mustye/src/profile/presentation/provider/edit_profile_provider.dart';
import 'package:mustye/src/profile/presentation/views/edit_profile_view.dart';
import 'package:mustye/src/setting/presentation/screen/settings_screen.dart';
import 'package:provider/provider.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: const Text(
          'Account',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton(
            offset: const Offset(0, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            itemBuilder: (_) => [
              PopupMenuItem<void>(
                child: const PopupItem(
                  title: 'Edit Profile',
                  icon: Icons.edit_outlined,
                ),
                onTap: () => context.push(
                  BlocProvider(
                    create: (context) => sl<AuthBloc>(),
                    child: ChangeNotifierProvider(
                      create: (_) => EditProfileProvider(),
                      child: const EditProfileView(),
                    ),
                  ),
                ),
              ),
              PopupMenuItem<void>(
                child: const PopupItem(
                  title: 'Notifications',
                  icon: Icons.notifications_outlined,
                ),
                onTap: () => context.push(
                  const Center(child: Text('Notifications Page')),
                ),
              ),
              PopupMenuItem<void>(
                child: const PopupItem(
                  title: 'Settings',
                  icon: Icons.settings_outlined,
                ),
                onTap: () => context.push(
                  const SettingsScreen(),
                ),
              ),
              PopupMenuItem<void>(
                child: const PopupItem(
                  title: 'Logout',
                  titleColor: Colors.red,
                  icon: Icons.logout_outlined,
                  iconColor: Colors.red,
                ),
                onTap: () async {
                  final navigator = Navigator.of(context);
                  await sl<FirebaseAuth>().signOut();
                  await sl<GoogleSignIn>().signOut();
                  unawaited(
                    navigator.pushNamedAndRemoveUntil('/', (route) => false),
                  );
                },
              ),
            ],
          ),
        ],
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
