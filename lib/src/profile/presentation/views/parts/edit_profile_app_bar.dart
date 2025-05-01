import 'package:flutter/material.dart';
import 'package:mustye/core/common/widgets/arrow_back_button.dart';
import 'package:mustye/src/setting/presentation/provider/setting_provider.dart';
import 'package:provider/provider.dart';

class EditProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EditProfileAppBar({required this.actions, super.key});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(
      builder:
          (context, provider, child) => AppBar(
            title: const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            leading: const ArrowBackButton(),
            actions: actions,
          ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
