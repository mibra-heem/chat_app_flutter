import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/app/widgets/gradient_background.dart';
import 'package:mustye/core/app/widgets/rounded_button.dart';
import 'package:mustye/core/constants/route_const.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/resources/fonts.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/core/utils/core_utils.dart';
import 'package:mustye/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:mustye/src/auth/presentation/screens/forms/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            CoreUtils.showSnackbar(context, state.message);
          } else if (state is SignedUp) {
            if (kDebugMode) print('Entered SignedUp State...');
            context.read<AuthBloc>().add(
              SignInEvent(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              ),
            );
          } else if (state is SignedIn) {
            if (kDebugMode) print('SignedIn state and User is : ${state.user}');
            sl<UserProvider>().cacheUserData(state.user);
            context.goNamed(RouteName.initial, extra: state.user);
          }
        },
        builder: (_, state) {
          return GradientBackground(
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const Text(
                    'Sign Up ',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      fontFamily: Fonts.aeonik,
                    ),
                  ),
                  SizedBox(height: context.height * 0.04),
                  SignUpForm(
                    formKey: formKey,
                    nameController: nameController,
                    emailController: emailController,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                  ),
                  SizedBox(height: context.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        style: const ButtonStyle(
                          padding: WidgetStatePropertyAll(EdgeInsets.zero),
                          minimumSize: WidgetStatePropertyAll(Size.zero),
                        ),
                        onPressed: () {
                          context.pushReplacementNamed(RouteName.signIn);
                        },
                        child: const Text('Log In'),
                      ),
                    ],
                  ),
                  SizedBox(height: context.height * 0.02),
                  if (state is AuthLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    RoundedButton(
                      'Create',
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        FirebaseAuth.instance.currentUser?.reload();
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            SignUpEvent(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              name: nameController.text.trim(),
                            ),
                          );
                        }
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
