import 'package:flutter/material.dart';
// import 'package:mustye/core/res/colors.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    required this.child, super.key,
    this.colors,
    });

  final Widget child;
  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints.expand(),
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       colors: colors ?? Colours.primaryGradient,
        //       begin: Alignment.topRight,
        //       end: Alignment.bottomLeft,),
        // ),
        child: SafeArea(
          child: child,
        ),
      );
  }
}
