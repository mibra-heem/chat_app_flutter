import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mustye/core/common/views/under_development_screen.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/src/auth/data/models/local_user_model.dart';
import 'package:mustye/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:mustye/src/auth/presentation/views/forgot_password_screen.dart';
import 'package:mustye/src/auth/presentation/views/sign_in_screen.dart';
import 'package:mustye/src/auth/presentation/views/sign_up_screen.dart';
import 'package:mustye/src/contact/presentation/cubit/contact_cubit.dart';
import 'package:mustye/src/contact/presentation/screen/contact_screen.dart';
import 'package:mustye/src/home/presentation/screen/home_screen.dart';
import 'package:mustye/src/profile/presentation/provider/edit_profile_provider.dart';
import 'package:mustye/src/profile/presentation/screens/edit_profile_screen.dart';
import 'package:mustye/src/profile/presentation/screens/profile_screen.dart';
import 'package:mustye/src/splash/presentation/views/splash_screen.dart';
import 'package:provider/provider.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.routeName:
      return _buildPage((context) {
        return const SplashScreen();
      }, settings: settings);

    case '/':
      // final prefs = sl<SharedPreferences>();
      final authClient = sl<FirebaseAuth>();

      return _buildPage((context) {
        if (authClient.currentUser != null) {
          final user = authClient.currentUser!;
          final localUser = LocalUserModel(
            uid: user.uid,
            email: user.email ?? '',
            fullName: user.displayName ?? '',
          );
          context.userProvider.initUser(localUser);

          return const HomeScreen();
        }
        return BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: const SignInScreen(),
        );
      }, settings: settings);

    case SignInScreen.routeName:
      return _buildPage(
        (_) => BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: const SignInScreen(),
        ),
        settings: settings,
      );

    case ForgotPasswordScreen.routeName:
      return _buildPage(
        (_) => BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: const ForgotPasswordScreen(),
        ),
        settings: settings,
      );

    case SignUpScreen.routeName:
      return _buildPage(
        (_) => BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: const SignUpScreen(),
        ),
        settings: settings,
      );
    case HomeScreen.routeName:
      return _buildPage((context) {
        return const HomeScreen();
      }, settings: settings);
    case ContactScreen.routeName:
      return _buildPage(
        (_) => BlocProvider(
          create: (context) => sl<ContactCubit>(),
          child: const ContactScreen(),
        ),
        settings: settings,
      );
    case ProfileScreen.routeName:
      return _buildPage(
        (_) => BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: const ProfileScreen(),
        ),
        settings: settings,
      );
    case EditProfileScreen.routeName:
      return _buildPage(
        (_) => BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: ChangeNotifierProvider(
            create: (_) => EditProfileProvider(),
            child: const EditProfileScreen(),
          ),
        ),
        settings: settings,
      );
    default:
      return _buildPage(
        (_) => const UnderDevelopmentScreen(),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _buildPage(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder:
        (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
    pageBuilder: (context, _, __) => page(context),
  );
}
