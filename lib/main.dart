import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/core/services/router.dart';
import 'package:mustye/firebase_options.dart';
import 'package:mustye/src/chat/presentation/provider/chat_provider.dart';
import 'package:mustye/src/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:mustye/src/setting/presentation/provider/setting_provider.dart';
import 'package:mustye/src/splash/presentation/views/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => sl<ChatProvider>()),
        ChangeNotifierProvider(create: (_) => sl<SettingProvider>()),
      ],
      child: const MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<SettingProvider>(context);
    return MaterialApp(
      title: 'Chat App',
      theme: themeProvider.theme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: generateRoute,
      initialRoute: SplashScreen.routeName,
    );
  }
}
