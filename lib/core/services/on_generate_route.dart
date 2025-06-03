import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mustye/core/app/views/under_development_screen.dart';
import 'package:mustye/core/constants/route_const.dart';
import 'package:mustye/core/extensions/context_extension.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:mustye/src/auth/presentation/screens/forgot_password_screen.dart';
import 'package:mustye/src/auth/presentation/screens/sign_in_screen.dart';
import 'package:mustye/src/auth/presentation/screens/sign_up_screen.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/contact/presentation/provider/contact_provider.dart';
import 'package:mustye/src/contact/presentation/screen/contact_screen.dart';
import 'package:mustye/src/message/presentation/provider/message_provider.dart';
import 'package:mustye/src/message/presentation/screen/message_screen.dart';
import 'package:mustye/src/splash/presentation/views/splash_screen.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  const RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.splash:
        return _buildPageRoute((context) {
          return const SplashScreen();
        }, settings: settings);
      case RoutePath.initial:
        final authClient = sl<FirebaseAuth>();
        return _buildPageRoute((context) {
          if (authClient.currentUser != null) {
            context.userProvider.getUserCachedData();
            return const SizedBox();
          }
          return BlocProvider(
            create: (context) => sl<AuthBloc>(),
            child: const SignInScreen(),
          );
        }, settings: settings);

      case RoutePath.signIn:
        return _buildPageRoute(
          (_) => BlocProvider(
            create: (context) => sl<AuthBloc>(),
            child: const SignInScreen(),
          ),
          settings: settings,
        );

      case RoutePath.forgetPassword:
        return _buildPageRoute(
          (_) => BlocProvider(
            create: (context) => sl<AuthBloc>(),
            child: const ForgotPasswordScreen(),
          ),
          settings: settings,
        );

      case RoutePath.signUp:
        return _buildPageRoute(
          (_) => BlocProvider(
            create: (context) => sl<AuthBloc>(),
            child: const SignUpScreen(),
          ),
          settings: settings,
        );
      case RoutePath.dashboard:
        return _buildPageRoute((_) {
          return const SizedBox();
        }, settings: settings);

      case RoutePath.contact:
        return _buildPageRoute(
          (_) => ChangeNotifierProvider(
            create: (context) => sl<ContactProvider>(),
            child: const ContactScreen(),
          ),
          settings: settings,
        );
      case RoutePath.message:
        return _buildPageRoute(
          (_) => ChangeNotifierProvider(
            create: (context) => sl<MessageProvider>(),
            child: const MessageScreen(chat: Chat.empty()),
          ),
          settings: settings,
        );
      default:
        return _buildPageRoute(
          (_) => const UnderDevelopmentScreen(),
          settings: settings,
        );
    }
  }

  static PageRouteBuilder<dynamic> _buildPageRoute(
    Widget Function(BuildContext) page, {
    required RouteSettings settings,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, __, ___) {
        return page(context);
      },
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
