import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mustye/core/common/widgets/popup_item.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/src/profile/presentation/screens/edit_profile_screen.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Account',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
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
              onTap: () => Navigator.pushNamed(
                context, 
                EditProfileScreen.routeName,
              ),
            ),
            PopupMenuItem<void>(
              child: const PopupItem(
                title: 'Notifications',
                icon: Icons.notifications_outlined,
              ),
              onTap: () => Navigator.pushNamed(
                context, 
                EditProfileScreen.routeName,
              ),
            ),
            PopupMenuItem<void>(
              child: const PopupItem(
                title: 'Settings',
                icon: Icons.settings_outlined,
              ),
              onTap: () => Navigator.pushNamed(
                context, 
                EditProfileScreen.routeName,
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
