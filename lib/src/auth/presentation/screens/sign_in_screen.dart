import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/app/widgets/gradient_background.dart';
import 'package:mustye/core/app/widgets/rounded_button.dart';
import 'package:mustye/core/constants/route_const.dart';
import 'package:mustye/core/resources/colors.dart';
import 'package:mustye/core/resources/fonts.dart';
import 'package:mustye/core/resources/media_res.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/core/utils/core_utils.dart';
import 'package:mustye/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:mustye/src/auth/presentation/screens/forms/sign_in_form.dart';
import 'package:mustye/src/auth/presentation/screens/widgets/auth_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

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
            sl<UserProvider>().cacheUserData(state.user);
            context.goNamed(RouteName.initial);
      
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
                  const Image(
                    height: 150,
                    width: 150,
                    image: AssetImage(
                      MediaRes.appPurpleIcon,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Sign In ',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      fontFamily: Fonts.aeonik,
                    ),
                  ),
                  const SizedBox(height: 40),
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
                        context.pushNamed(RouteName.forgetPassword);
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colours.grey600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 20),
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
                          context.pushNamed(RouteName.signUp);
                        },
                        child: const Text('Create Account'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    spacing: 12,
                    children: <Widget>[
                      Expanded(
                        child: Divider(thickness: 1),
                      ),
                      Text('OR'),
                      Expanded(
                        child: Divider(thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 12,
                    children: [
                      AuthButton(
                        image: const AssetImage(MediaRes.googleIcon),
                        color: Colors.orange,
                        onTap: () {
                          context.read<AuthBloc>().add(
                            const GoogleSignInEvent(),
                          );
                        },
                      ),
                      const AuthButton(
                        image: AssetImage(MediaRes.facebookIcon),
                        color: Colors.blueAccent,
                      ),
                      const AuthButton(
                        image: AssetImage(MediaRes.xIcon),
                        color: Colors.black,
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
