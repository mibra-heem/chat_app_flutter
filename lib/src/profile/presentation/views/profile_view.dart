import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mustye/core/common/widgets/gradient_background.dart';
import 'package:mustye/src/profile/presentation/views/parts/profile_app_bar.dart';
import 'package:mustye/src/profile/presentation/views/parts/profile_body.dart';
import 'package:mustye/src/profile/presentation/views/parts/profile_header.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    if(kDebugMode) print('........ ProfileView building .......');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const ProfileAppBar(),
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: const [
            ProfileHeader(),
            SizedBox(height: 20),
            ProfileBody(),
          ],
        ),
      ),
    );
  }
}
