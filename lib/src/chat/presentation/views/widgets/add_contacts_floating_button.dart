import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/src/contact/presentation/screen/contact_screen.dart';

class AddContactsFloatingButton extends StatelessWidget {
  const AddContactsFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      foregroundColor: Colors.white,
      tooltip: 'Select Contacts',
      shape: const CircleBorder(),
      onPressed: (){
        Navigator.pushNamed(context, ContactScreen.routeName);
      },
      child: const Icon(IconlyBold.add_user),

    );
  }
}
