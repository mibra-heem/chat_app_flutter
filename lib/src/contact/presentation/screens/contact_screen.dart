import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mustye/core/app/resources/colors.dart';
import 'package:mustye/core/app/widgets/contact_tile.dart';
import 'package:mustye/core/config/route_config.dart';
import 'package:mustye/core/services/contacts_service.dart';
import 'package:mustye/src/contact/data/models/contact_model.dart';
import 'package:mustye/src/contact/domain/entities/local_contact.dart';
import 'package:mustye/src/contact/domain/entities/remote_contact.dart';
import 'package:mustye/src/contact/presentation/provider/contact_provider.dart';
import 'package:provider/provider.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ContactProvider>().getContacts();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContactProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Contacts')),
      body: FutureBuilder<List<LocalContactModel>>(
        future: ContactService.getFilteredContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final localContacts = snapshot.data ?? [];

          final allItems = <dynamic>[];

          final registeredContacts = <RemoteContact>[];
          final nonRegisteredContacts = <LocalContact>[];

          // Separate into registered and non-registered
          for (final contact in localContacts) {
            final user = provider.findRegisteredUserByPhone(contact.phone);
            if (user.isNotEmpty) {
              registeredContacts.add(user);
            } else {
              nonRegisteredContacts.add(contact);
            }
          }

          // Build the final list
          if (registeredContacts.isNotEmpty) {
            allItems
              ..add('Contacts on App')
              ..addAll(registeredContacts);
          }

          if (nonRegisteredContacts.isNotEmpty) {
            allItems
              ..add('Invite on App')
              ..addAll(nonRegisteredContacts);
          }

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContactTile.noSubtitle(title: 'New Group'),
                      ContactTile.noSubtitle(title: 'New Contact'),
                    ],
                  ),
                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = allItems[index];

                    if (item is String) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          item,
                          style: const TextStyle(color: Colours.neutral),
                        ),
                      );
                    } else if (item is RemoteContact) {
                      return ContactTile(
                        title: item.name,
                        subtitle: item.bio ?? '',
                        image: item.avatar,
                        onTap: () {
                          context.pushNamed(
                            RouteName.message,
                            
                          );
                        },
                      );
                    } else if (item is LocalContact) {
                      return ContactTile(
                        title: item.name,
                        subtitle: item.phone,
                        trailing: 'invite',
                      );
                    }

                    return const SizedBox.shrink();
                  }, childCount: allItems.length),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
