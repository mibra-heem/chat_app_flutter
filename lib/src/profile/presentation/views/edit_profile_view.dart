import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mustye/core/app/widgets/gradient_background.dart';
import 'package:mustye/core/enums/update_user_action.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/resources/colors.dart';
import 'package:mustye/core/utils/core_utils.dart';
import 'package:mustye/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:mustye/src/profile/presentation/provider/profile_provider.dart';
import 'package:mustye/src/profile/presentation/views/form/edit_profile_form.dart';
import 'package:mustye/src/profile/presentation/views/parts/edit_profile_app_bar.dart';
import 'package:mustye/src/profile/presentation/views/widgets/edit_profile_image.dart';
import 'package:provider/provider.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();
  final passwordController = TextEditingController();
  final oldPasswordController = TextEditingController();

  bool get nameChanged =>
      context.currentUser?.name.trim() != nameController.text.trim();

  bool get emailChanged => emailController.text.trim().isNotEmpty;

  bool get bioChanged =>
      context.currentUser?.bio?.trim() != bioController.text.trim();

  bool get passwordChanged => passwordController.text.trim().isNotEmpty;

  bool get nothingChanged =>
      !nameChanged && !emailChanged && !bioChanged && !passwordChanged;

  @override
  void initState() {
    nameController.text = context.currentUser!.name.trim();
    bioController.text = context.currentUser!.bio ?? '';
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    passwordController.dispose();
    oldPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (_, state) {
        if (state is UserUpdated) {
          CoreUtils.showSnackbar(context, 'Profile updated successfully.');
          Navigator.pop(context);
        } else if (state is AuthError) {
          CoreUtils.showSnackbar(context, state.message);
        }
      },
      builder: (_, state) {
        return Scaffold(
          appBar: EditProfileAppBar(
            actions: [
              Consumer<ProfileProvider>(
                builder: (_, provider, __) {
                  return TextButton(
                    onPressed: () {
                      if (nothingChanged) context.pop();
                      final bloc = context.read<AuthBloc>();
                      if (passwordChanged) {
                        if (oldPasswordController.text.trim().isEmpty) {
                          CoreUtils.showSnackbar(
                            context,
                            'Please enter your old password',
                          );
                          return;
                        }
                        bloc.add(
                          UpdateUserEvent(
                            action: UpdateUserAction.password,
                            userData: jsonEncode({
                              'oldPassword': oldPasswordController.text.trim(),
                              'newPassword': passwordController.text.trim(),
                            }),
                          ),
                        );
                      }
                      if (nameChanged) {
                        bloc.add(
                          UpdateUserEvent(
                            action: UpdateUserAction.displayName,
                            userData: nameController.text.trim(),
                          ),
                        );
                      }
                      if (emailChanged) {
                        bloc.add(
                          UpdateUserEvent(
                            action: UpdateUserAction.email,
                            userData: emailController.text.trim(),
                          ),
                        );
                      }
                      if (bioChanged) {
                        bloc.add(
                          UpdateUserEvent(
                            action: UpdateUserAction.bio,
                            userData: bioController.text.trim(),
                          ),
                        );
                      }
                      if (provider.imageChanged) {
                        bloc.add(
                          UpdateUserEvent(
                            action: UpdateUserAction.image,
                            userData: provider.pickedImage,
                          ),
                        );
                      }
                    },
                    child:
                        state is AuthLoading
                            ? const Center(
                              child: CircularProgressIndicator(
                                color: Colours.white,
                              ),
                            )
                            : StatefulBuilder(
                              builder: (_, refresh) {
                                nameController.addListener(
                                  () => refresh(() {}),
                                );
                                emailController.addListener(
                                  () => refresh(() {}),
                                );
                                bioController.addListener(() => refresh(() {}));
                                passwordController.addListener(
                                  () => refresh(() {}),
                                );
                                return Text(
                                  'Done',
                                  style: TextStyle(
                                    color:
                                        nothingChanged && !provider.imageChanged
                                            ? Colors.grey
                                            : Colours.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                  );
                },
              ),
              
            ],
          ),
          body: GradientBackground(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 20),
                EditProfileImage(user: context.currentUser!),
                const SizedBox(height: 30),
                EditProfileForm(
                  emailController: emailController,
                  nameController: nameController,
                  passwordController: passwordController,
                  oldPasswordController: oldPasswordController,
                  bioController: bioController,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
