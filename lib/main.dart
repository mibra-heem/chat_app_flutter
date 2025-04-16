import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/res/colors.dart';
import 'package:mustye/core/res/fonts.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/core/services/router.dart';
import 'package:mustye/firebase_options.dart';
import 'package:mustye/src/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:mustye/src/splash/presentation/views/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: Fonts.poppins,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            color: Colors.transparent,
          ),
          primaryColor: Colours.primaryColor,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colours.primaryColor,
            accentColor: Colours.primaryColor,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            foregroundColor: Colors.white,
            backgroundColor: Colours.primaryColor,
          )
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: generateRoute,
        initialRoute: SplashScreen.routeName,
      ),
    );
  }
}
