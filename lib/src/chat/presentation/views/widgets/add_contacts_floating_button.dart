import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mustye/core/config/route_config.dart';

class AddContactsFloatingButton extends StatelessWidget {
  const AddContactsFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      foregroundColor: Colors.white,
      tooltip: 'Select Contacts',
      shape: const CircleBorder(),
      onPressed: () {
        context.pushNamed(RouteName.contact);
      },
      child: const Icon(LucideIcons.userPlus),
    );
  }
}
