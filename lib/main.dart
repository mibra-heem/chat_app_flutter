import 'package:flutter/material.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/constants/constants.dart';
import 'package:mustye/core/resources/themes.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/core/services/go_router.dart';
import 'package:mustye/core/services/notification_service.dart';
import 'package:mustye/src/chat/presentation/provider/chat_provider.dart';
import 'package:mustye/src/message/features/call/audio/presentation/provider/audio_call_provider.dart';
import 'package:mustye/src/profile/features/theme/presentation/provider/theme_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<UserProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ChatProvider>()),
        ChangeNotifierProvider(create: (_) => sl<AudioCallProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ThemeProvider>()),
      ],
      child: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    NotificationService.handleInitialMessage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: appName,
      darkTheme: AppTheme.dark,
      theme: AppTheme.light,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      debugShowCheckedModeBanner: false,
    );
  }
}
