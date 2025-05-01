import 'package:flutter/material.dart';
import 'package:mustye/core/common/widgets/my_field.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({
    required this.formKey,
    required this.emailController,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: MyField(
        controller: widget.emailController,
        hintText: 'Email Address',
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}
