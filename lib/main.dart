import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mustye/core/app/providers/user_provider.dart';
import 'package:mustye/core/services/dependency_injection.dart';
import 'package:mustye/core/services/router.dart';
import 'package:mustye/firebase_options.dart';
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
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
