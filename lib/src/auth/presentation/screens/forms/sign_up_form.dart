import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/app/widgets/my_field.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    required this.formKey,
    required this.emailController,
    required this.nameController,
    required this.passwordController,
    required this.confirmPasswordController,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          MyField(
            controller: widget.nameController,
            hintText: 'Full Name',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 25),

          MyField(
            controller: widget.emailController,
            hintText: 'Email Address',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 25),

          MyField(
            controller: widget.passwordController,
            hintText: 'Password',
            obscureText: obscurePassword,
            validatePassword: true,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              icon: Icon(
                obscurePassword ? IconlyLight.show : IconlyLight.hide,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 25),

          MyField(
            controller: widget.confirmPasswordController,
            hintText: 'Confirm Password',
            obscureText: obscurePassword,
            overrideValidator: true,
            validator: (value) {
              if (widget.passwordController.text.trim() != value!.trim()) {
                return 'This should match password field.';
              }
              return null;
            },
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              icon: Icon(
                obscurePassword ? IconlyLight.show : IconlyLight.hide,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
