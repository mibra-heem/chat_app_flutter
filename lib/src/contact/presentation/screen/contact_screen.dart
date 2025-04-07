import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mustye/core/common/views/loading_view.dart';
import 'package:mustye/core/common/widgets/gradient_background.dart';
import 'package:mustye/core/res/fonts.dart';
import 'package:mustye/core/res/media_res.dart';
import 'package:mustye/core/utils/core_utils.dart';
import 'package:mustye/src/contact/presentation/cubit/contact_cubit.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  static const routeName = '/contacts';

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {

  void getContacts() {
    context.read<ContactCubit>().getContacts();
  }

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocConsumer<ContactCubit, ContactState>(
        listener: (context, state) {
          if (state is ContactError) {
            CoreUtils.showSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is LoadingContacts) {
            return const LoadingView();
          } else if (state is ContactsLoaded) {
            if(kDebugMode) print('....... Contacts : ${state.contacts} ......');
            return GradientBackground(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.white,
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
                          'Total Contacts ${state.contacts.length}', 
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SliverList.builder(
                    itemCount: state.contacts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.contacts[index].fullName),
                        subtitle: Text(state.contacts[index].bio ?? ''),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: state.contacts[index].image != null 
                                ? NetworkImage(state.contacts[index].image!) 
                                : const AssetImage(
                                    MediaRes.youngManWorkingOnDesk,
                                ) as ImageProvider,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
