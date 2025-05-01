import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/src/profile/presentation/views/widgets/user_info_card.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        // final user = provider.user;
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                UserInfoCard(
                  title: 'Groups',
                  value: '2',
                  icon: IconlyLight.document,
                  iconColor: Colors.purple,
                ),
                UserInfoCard(
                  title: 'Scores',
                  value: '17',
                  icon: IconlyLight.chart,
                  iconColor: Colors.lightGreen,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                UserInfoCard(
                  title: 'Favourites',
                  value: '3',
                  icon: IconlyLight.user_1,
                  iconColor: Colors.lightBlue,
                ),
                UserInfoCard(
                  title: 'Friends',
                  value: '18',
                  icon: IconlyLight.user_1,
                  iconColor: Colors.red,
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
          ],
        );
      },
    );
  }
}
