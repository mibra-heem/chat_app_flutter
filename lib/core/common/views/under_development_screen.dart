

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mustye/core/common/widgets/gradient_background.dart';
import 'package:mustye/core/res/media_res.dart';

class UnderDevelopmentScreen extends StatelessWidget {
  const UnderDevelopmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GradientBackground(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Lottie.asset(MediaRes.underDevelopmentScreen),
              const Text(
                'Page Under Development',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
    );
  }
}
