import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/src/contact/presentation/screen/contact_screen.dart';
import 'package:mustye/src/profile/presentation/screens/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    if(kDebugMode) print('...... Current User : ${context.currentUser} ......');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats', style: TextStyle(fontSize: 32),),
        leading: IconButton(
          icon: const Icon(IconlyLight.profile),
          onPressed: (){
            Navigator.pushNamed(context, ProfileScreen.routeName);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, ContactScreen.routeName);
        },
        child: const Icon(IconlyLight.add_user),
      ),
      body: const Center(
        child: Text('Home Page', style: TextStyle(fontSize: 32),),),
    );
  }
}
