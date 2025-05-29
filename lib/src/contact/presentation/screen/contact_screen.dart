import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mustye/core/app/views/loading_view.dart';
import 'package:mustye/core/app/widgets/contact_tile.dart';
import 'package:mustye/core/constants/route_const.dart';
import 'package:mustye/core/res/fonts.dart';
import 'package:mustye/core/utils/stream_utils.dart';
import 'package:mustye/src/chat/data/model/chat_model.dart';
import 'package:mustye/src/contact/domain/entity/contact.dart';
import 'package:mustye/src/contact/presentation/provider/contact_provider.dart';
import 'package:provider/provider.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: StreamBuilder<List<Contact>>(
        stream: StreamUtils.getContacts,
        builder: (context, snapshot) {
          if (kDebugMode) print('....... Getting Contacts .........');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading contacts = ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No contacts found.'));
          }
          final contacts = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Contacts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: Fonts.aeonik,
                      ),
                    ),
                    Text(
                      'Total Contacts ${contacts.length}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final contact = contacts[index];
                  return Consumer<ContactProvider>(
                    builder: (context, provider, child) {
                      return ContactTile(
                        title: contact.name,
                        subtitle: contact.bio ?? '',
                        image: contact.image,
                        onTap: () {
                          context.pushReplacementNamed(
                            RouteName.message, 
                            extra: ChatModel(
                              uid: contact.uid,
                              name: contact.name,
                              email: contact.email,
                              image: contact.image,
                              bio: contact.bio,
                            ),
                          );
                        },
                      );
                    },
                  );
                }, childCount: contacts.length,),
              ),
            ],
          );
        },
      ),
    );
  }
}
