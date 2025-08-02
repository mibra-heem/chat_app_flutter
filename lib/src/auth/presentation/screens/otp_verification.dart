import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mustye/core/app/resources/colors.dart';
import 'package:mustye/core/app/resources/media_res.dart';
import 'package:mustye/core/app/views/loading_view.dart';
import 'package:mustye/core/app/widgets/rounded_button.dart';
import 'package:mustye/core/config/route_config.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/utils/core_utils.dart';
import 'package:mustye/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:otpify/otpify.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {

  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            CoreUtils.showSnackbar(context, state.message);
          } else if (state is PhoneAuthSuccess) {
            context.goNamed(RouteName.initial);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const LoadingView();
          }
      
          return Padding(
            padding: const EdgeInsets.all(16),
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
                Otpify(
                  fields: 6,
                  fieldColor: context.color.surfaceBright,
                  fieldTextStyle: context.text.bodyMedium,
                  resendDisableColor: Colours.disable,
                  focusedBorderColor: Colours.primary,
                  onCompleted: (otp) {
                    otpController.text = otp;
                    debugPrint(otp);
                  },
                ),
                const SizedBox(height: 20),
                RoundedButton(
                  'Verify',
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    FirebaseAuth.instance.currentUser?.reload();
                    if (formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                        VerifyOTPEvent(otpController.text.trim()),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
