
// Route<dynamic> generateRoute(RouteSettings settings) {
//   switch (settings.name) {
//     case '/':
//       final prefs = sl<SharedPreferences>();
//       final authClient = sl<FirebaseAuth>();

//       return _buildPage(
//         (context) {
//           if (prefs.getBool(kFirstTimerKey) ?? true) {
//             return BlocProvider(
//               create: (context) => sl<OnBoardingCubit>(),
//               child: const OnBoardingScreen(),
//             );
//           } else if (authClient.currentUser != null) {
//             final user = authClient.currentUser!;
//             final localUser = UserModel(
//               uid: user.uid,
//               email: user.email ?? '',
//               points: 0,
//               fullName: user.displayName ?? '',
//             );
//             context.userProvider.initUser(localUser);

//             return const Dashboard();
//           }
//           return BlocProvider(
//             create: (context) => sl<AuthBloc>(),
//             child: const SignInScreen(),
//           );
//         },
//         settings: settings,
//       );

//     case SignInScreen.routeName:
//       return _buildPage(
//         (_) => BlocProvider(
//           create: (context) => sl<AuthBloc>(),
//           child: const SignInScreen(),
//         ),
//         settings: settings,
//       );
    
//     case ForgotPasswordScreen.routeName:
//       return _buildPage(
//         (_) => BlocProvider(
//           create: (context) => sl<AuthBloc>(),
//           child: const ForgotPasswordScreen(),
//         ),
//         settings: settings,
//       );

//     case SignUpScreen.routeName:
//       return _buildPage(
//         (_) => BlocProvider(
//           create: (context) => sl<AuthBloc>(),
//           child: const SignUpScreen(),
//         ),
//         settings: settings,
//       );

//     case Dashboard.routeName:
//       return _buildPage(
//         (_) => const Dashboard(),
//         settings: settings,
//       );
//     default:
//       return _buildPage(
//         (_) => const UnderDevelopmentScreen(),
//         settings: settings,
//       );
//   }
// }

// PageRouteBuilder<dynamic> _buildPage(
//   Widget Function(BuildContext) page, {
//   required RouteSettings settings,
// }) {
//   return PageRouteBuilder(
//     settings: settings,
//     transitionsBuilder: (_, animation, __, child) => FadeTransition(
//       opacity: animation,
//       child: child,
//     ),
//     pageBuilder: (context, _, __) => page(context),
//   );
// }
