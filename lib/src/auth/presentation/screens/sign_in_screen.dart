import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mustye/core/common/widgets/gradient_background.dart';
import 'package:mustye/core/common/widgets/rounded_button.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/res/colors.dart';
import 'package:mustye/core/res/fonts.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/core/utils/core_utils.dart';
import 'package:mustye/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:mustye/src/auth/presentation/screens/forgot_password_screen.dart';
import 'package:mustye/src/auth/presentation/screens/forms/sign_in_form.dart';
import 'package:mustye/src/auth/presentation/screens/sign_up_screen.dart';
import 'package:mustye/src/auth/presentation/screens/widgets/auth_button.dart';
import 'package:mustye/src/dashboard/presentation/view/dashboard.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            CoreUtils.showSnackbar(context, state.message);
          } else if (state is SignedIn) {
            context.userProvider.cacheUserData(state.user);
            context.settingProvider.loadInitialTheme();
            Navigator.pushReplacementNamed(context, Dashboard.routeName);
            if (kDebugMode) print('........ Signed In successfully ........');
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
                    'Sign In ',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      fontFamily: Fonts.aeonik,
                    ),
                  ),
                  SizedBox(height: context.height * 0.04),
                  SignInForm(
                    formKey: formKey,
                    emailController: emailController,
                    passwordController: passwordController,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.zero),
                        splashFactory: NoSplash.splashFactory,

                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) {
                              return BlocProvider(
                                create: (_) => sl<AuthBloc>(),
                                child: const ForgotPasswordScreen(),
                              );
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password?', 
                        style: TextStyle(
                          color: Colours.grey,
                        ),),
                    ),
                  ),
                  SizedBox(height: context.height * 0.02),
                  if (state is AuthLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    RoundedButton(
                      'Sign In',
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        FirebaseAuth.instance.currentUser?.reload();
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            SignInEvent(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            ),
                          );
                        }
                      },
                    ),
                  SizedBox(height: context.height * 0.02),
                  const Row(
                    spacing: 10,
                    children: <Widget>[
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.black),
                      ),
                      Text('OR'),
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: context.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      AuthButton(
                        title: 'G',
                        color: Colors.orange,
                        onTap: () {
                          context.read<AuthBloc>().add(
                            const GoogleSignInEvent(),
                          );
                        },
                      ),
                      const AuthButton(title: 'f', color: Colors.blueAccent),
                      const AuthButton(title: 'X', color: Colors.black),
                    ],
                  ),
                  SizedBox(height: context.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) {
                                return BlocProvider(
                                  create: (_) => sl<AuthBloc>(),
                                  child: const SignUpScreen(),
                                );
                              },
                            ),
                          );
                        },
                        child: const Text('Create Account'),
                      ),
                    ],
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
