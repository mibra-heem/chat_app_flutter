import 'package:flutter/material.dart';
import 'package:mustye/core/common/widgets/gradient_background.dart';
import 'package:mustye/src/profile/presentation/parts/profile_app_bar.dart';
import 'package:mustye/src/profile/presentation/parts/profile_body.dart';
import 'package:mustye/src/profile/presentation/parts/profile_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: const ProfileAppBar(),
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: const [
            ProfileHeader(),
            SizedBox(height: 20,),
            ProfileBody(),
          ],
        ),
      ),
    );
  }
}
