import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mustye/core/constants/route_const.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:mustye/src/auth/presentation/screens/forgot_password_screen.dart';
import 'package:mustye/src/auth/presentation/screens/sign_in_screen.dart';
import 'package:mustye/src/auth/presentation/screens/sign_up_screen.dart';
import 'package:mustye/src/chat/domain/entity/chat.dart';
import 'package:mustye/src/chat/presentation/views/chat_view.dart';
import 'package:mustye/src/contact/presentation/provider/contact_provider.dart';
import 'package:mustye/src/contact/presentation/screens/contact_screen.dart';
import 'package:mustye/src/dashboard/presentation/view/dashboard.dart';
import 'package:mustye/src/message/features/call/audio/data/models/incoming_audio_call_model.dart';
import 'package:mustye/src/message/features/call/audio/domain/entities/incoming_audio_call.dart';
import 'package:mustye/src/message/features/call/audio/presentation/provider/audio_call_provider.dart';
import 'package:mustye/src/message/features/call/audio/presentation/screens/audio_call_screen.dart';
import 'package:mustye/src/message/features/call/audio/presentation/screens/incoming_audio_call_screen.dart';
import 'package:mustye/src/message/features/call/video/presentation/screens/video_call_screen.dart';
import 'package:mustye/src/message/presentation/provider/message_provider.dart';
import 'package:mustye/src/message/presentation/screen/message_screen.dart';
import 'package:mustye/src/profile/features/theme/presentation/provider/theme_provider.dart';
import 'package:mustye/src/profile/presentation/provider/profile_provider.dart';
import 'package:mustye/src/profile/presentation/views/edit_profile_view.dart';
import 'package:mustye/src/profile/presentation/views/profile_view.dart';
import 'package:mustye/src/splash/presentation/views/splash_screen.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: RoutePath.splash,
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: RoutePath.splash,
      name: RouteName.splash,
      builder: (context, state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: RoutePath.initial,
      name: RouteName.initial,
      redirect: (context, state) {
        if (sl<FirebaseAuth>().currentUser != null) {
          debugPrint('Before startListening method................');
          sl<ThemeProvider>().loadTheme();
          sl<AudioCallProvider>().listeningForCall(context);
          sl<AudioCallProvider>().listeningToCallReject(context);
          sl<AudioCallProvider>().listenToCallerHangupBeforeAnswer(context);

          return RoutePath.chat;
        }
        return RoutePath.signIn;
      },
    ),
    GoRoute(
      path: RoutePath.signIn,
      name: RouteName.signIn,
      builder:
          (context, state) => BlocProvider(
            create: (context) => sl<AuthBloc>(),
            child: const SignInScreen(),
          ),
    ),
    GoRoute(
      path: RoutePath.signUp,
      name: RouteName.signUp,
      builder:
          (context, state) => BlocProvider(
            create: (context) => sl<AuthBloc>(),
            child: const SignUpScreen(),
          ),
    ),
    GoRoute(
      path: RoutePath.forgetPassword,
      name: RouteName.forgetPassword,
      builder:
          (context, state) => BlocProvider(
            create: (context) => sl<AuthBloc>(),
            child: const ForgotPasswordScreen(),
          ),
    ),
    GoRoute(
      path: RoutePath.message,
      name: RouteName.message,
      builder: (context, state) {
        final chat = state.extra! as Chat;
        return ChangeNotifierProvider(
          create: (context) => sl<MessageProvider>(),
          child: MessageScreen(chat: chat),
        );
      },
    ),
    GoRoute(
      path: RoutePath.audioCall,
      name: RouteName.audioCall,
      builder: (context, state) {
        final call = state.extra! as AudioCallModel;
        return AudioCallScreen(call: call);
      },
    ),
    GoRoute(
      path: RoutePath.incomingAudioCall,
      name: RouteName.incomingAudioCall,
      builder: (context, state) {
        final call = state.extra! as AudioCall;
        return IncomingAudioCallScreen(call: call);
      },
    ),
    GoRoute(
      path: RoutePath.videoCall,
      name: RouteName.videoCall,
      builder: (context, state) {
        final chat = state.extra! as Chat;
        return VideoCallScreen(chat: chat);
      },
    ),
    GoRoute(
      path: RoutePath.contact,
      name: RouteName.contact,
      builder:
          (context, state) => ChangeNotifierProvider(
            create: (context) => sl<ContactProvider>(),
            child: const ContactScreen(),
          ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) {
        return Dashboard(shell: shell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePath.chat,
              name: RouteName.chat,
              builder: (context, state) => const ChatView(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePath.profile,
              name: RouteName.profile,
              builder: (context, state) => const ProfileView(),
            ),
            GoRoute(
              path: RoutePath.editProfile,
              name: RouteName.editProfile,
              builder:
                  (context, state) => BlocProvider(
                    create: (context) => sl<AuthBloc>(),
                    child: ChangeNotifierProvider(
                      create: (_) => ProfileProvider(),
                      child: const EditProfileView(),
                    ),
                  ),
            ),
            GoRoute(
              path: RoutePath.favourite,
              name: RouteName.favourite,
              builder:
                  (context, state) =>
                      const Center(child: Text('Favourite View')),
            ),
            GoRoute(
              path: RoutePath.notification,
              name: RouteName.notification,
              builder:
                  (context, state) =>
                      const Center(child: Text('Notification View')),
            ),
            GoRoute(
              path: RoutePath.privacy,
              name: RouteName.privacy,
              builder:
                  (context, state) => const Center(child: Text('Privacy View')),
            ),
          ],
        ),
      ],
    ),
  ],
);
