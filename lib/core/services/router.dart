import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mustye/core/common/views/under_development_screen.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/src/auth/data/models/local_user_model.dart';
import 'package:mustye/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:mustye/src/auth/presentation/screens/forgot_password_screen.dart';
import 'package:mustye/src/auth/presentation/screens/sign_in_screen.dart';
import 'package:mustye/src/auth/presentation/screens/sign_up_screen.dart';
import 'package:mustye/src/contact/presentation/provider/contact_provider.dart';
import 'package:mustye/src/contact/presentation/screen/contact_screen.dart';
import 'package:mustye/src/dashboard/presentation/view/dashboard.dart';
import 'package:mustye/src/message/presentation/provider/message_provider.dart';
import 'package:mustye/src/message/presentation/screen/message_screen.dart';
import 'package:mustye/src/splash/presentation/views/splash_screen.dart';
import 'package:provider/provider.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.routeName:
      return _buildPage((context) {
        return const SplashScreen();
      }, settings: settings,);

    case '/':
      final authClient = sl<FirebaseAuth>();

      return _buildPage((context) {
        if (authClient.currentUser != null) {
          context.userProvider.getUserCachedData();
          return const Dashboard();
        }
        return BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: const SignInScreen(),
        );
      }, settings: settings,);

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
    case Dashboard.routeName:
      return _buildPage((_) {
        return const Dashboard();
      }, settings: settings,);
    case ContactScreen.routeName:
      return _buildPage(
        (_) => ChangeNotifierProvider(
          create: (context) => sl<ContactProvider>(),
          child: const ContactScreen(),
        ),
        settings: settings,
      );
    case MessageScreen.routeName:
      return _buildPage(
        (_) => ChangeNotifierProvider(
          create: (context) => sl<MessageProvider>(),
          child: const MessageScreen(),
        ),
        settings: settings,
      );
    // case ProfileView.routeName:
    //   return _buildPage(
    //     (_) => BlocProvider(
    //       create: (context) => sl<AuthBloc>(),
    //       child: const ProfileView(),
    //     ),
    //     settings: settings,
    //   );
    // case EditProfileView.routeName:
    //   return _buildPage(
    //     (_) => BlocProvider(
    //       create: (context) => sl<AuthBloc>(),
    //       child: ChangeNotifierProvider(
    //         create: (_) => EditProfileProvider(),
    //         child: const EditProfileView(),
    //       ),
    //     ),
    //     settings: settings,
    //   );
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
