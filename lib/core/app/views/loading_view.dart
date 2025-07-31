import 'package:flutter/material.dart';
import 'package:mustye/core/extensions/context_extension.dart';


class LoadingView extends StatelessWidget{

  const LoadingView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            context.color.primary,
          ),
        ),
      ),
    );
  }

  
}
