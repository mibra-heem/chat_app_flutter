import 'package:flutter/material.dart';
import 'package:mustye/core/extensions/context_extension.dart';

class ArrowBackButton extends StatelessWidget {
  const ArrowBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){
        // try{
        //   // context.pop();
        // } on Exception catch(_){
          Navigator.of(context).pop();
        // }
      }, 
      icon: Icon(
        Theme.of(context).platform == TargetPlatform.iOS 
        ? Icons.arrow_back_ios_new 
        : Icons.arrow_back,
    
      ),
    );
  }
}
