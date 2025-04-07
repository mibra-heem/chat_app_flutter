import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mustye/core/common/widgets/my_field.dart';
import 'package:mustye/core/extensions/context_extension.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          MyField(
            controller: widget.emailController,
            hintText: 'Email Address',
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: context.height * 0.03,),
          MyField(
            controller: widget.passwordController,
            hintText: 'Password',
            obscureText: obscurePassword,
            validatePassword: true,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              onPressed: (){
                setState((){
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
