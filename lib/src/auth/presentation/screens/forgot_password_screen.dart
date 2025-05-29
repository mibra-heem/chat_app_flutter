import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mustye/core/app/widgets/gradient_background.dart';
import 'package:mustye/core/app/widgets/rounded_button.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/res/colors.dart';
import 'package:mustye/core/res/fonts.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/core/utils/core_utils.dart';
import 'package:mustye/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:mustye/src/auth/presentation/screens/forms/forgot_password_form.dart';
import 'package:mustye/src/auth/presentation/screens/sign_in_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            CoreUtils.showSnackbar(context, '');
          } else if (state is ForgotPasswordSent) {
            // Navigator.pushReplacementNamed(context, SignInScreen.routeName);
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
                    'Forgotten Password',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      fontFamily: Fonts.aeonik,
                    ),
                  ),
                  SizedBox(height: context.height * 0.04),
                  const Text(
                    'Provide your email and we will send you a link to '
                    'reset your password.',
                  ),
                  SizedBox(height: context.height * 0.06),
                  ForgotPasswordForm(
                    formKey: formKey,
                    emailController: emailController,
                  ),
                  SizedBox(height: context.height * 0.04),
                  RoundedButton(
                    'Reset Password',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                          ForgotPasswordEvent(
                            email: emailController.text.trim(),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: context.height * 0.02),
                  RoundedButton(
                    'Go back',
                    labelColor: Colours.primary,
                    buttonColor: Colors.white,
                    elevation: 0,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) {
                            return BlocProvider(
                              create: (_) => sl<AuthBloc>(),
                              child: const SignInScreen(),
                            );
                          },
                        ),
                      );
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
