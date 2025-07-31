import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/config/route_config.dart';

class AddContactsFloatingButton extends StatelessWidget {
  const AddContactsFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      foregroundColor: Colors.white,
      tooltip: 'Select Contacts',
      shape: const CircleBorder(),
      onPressed: (){
        context.pushNamed(RouteName.contact);
      },
      child: const Icon(IconlyBold.add_user),

    );
  }
}
