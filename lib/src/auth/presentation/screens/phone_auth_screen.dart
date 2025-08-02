import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mustye/core/app/resources/media_res.dart';
import 'package:mustye/core/app/views/loading_view.dart';
import 'package:mustye/core/app/widgets/gradient_background.dart';
import 'package:mustye/core/app/widgets/my_field.dart';
import 'package:mustye/core/app/widgets/rounded_button.dart';
import 'package:mustye/core/config/route_config.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/utils/core_utils.dart';
import 'package:mustye/src/auth/presentation/bloc/auth_bloc.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Center(
              child: Image(
                height: 150,
                width: 150,
                image: AssetImage(MediaRes.appPurpleIcon),
              ),
            ),
            const SizedBox(height: 50),
            Text(
              'Create an account',
              style: context.text.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 25),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is OTPSent) {
                  debugPrint('state is OTPSent.');
                  context.pushNamed(
                    RouteName.verifyOtp,
                    pathParameters: {'phone': phoneController.text.trim()},
                  );
                } else if (state is AuthError) {
                  CoreUtils.showSnackbar(context, state.message);
                }
              },
              builder: (context, state) {
                return Form(
                  key: formKey,
                  child: Column(
                    spacing: 20,
                    children: [
                      MyField(
                        controller: phoneController,
                        hintText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                      ),
                      if (state is AuthLoading)
                        const LoadingView()
                      else
                        RoundedButton(
                          'Send OTP',
                          width: context.width / 2.5,
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            FirebaseAuth.instance.currentUser?.reload();
                            if (formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                PhoneAuthenticationEvent(
                                  phoneController.text.trim(),
                                ),
                              );
                            }
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
