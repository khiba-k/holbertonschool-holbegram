import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:holbegram/screens/auth/login_screen.dart';
import 'package:holbegram/screens/pages/main_layout.dart';
import 'providers/user_provider.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'Holbegram',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const LoginScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const MainLayout(initialIndex: 0),
          '/feed': (context) => const MainLayout(initialIndex: 0),
          '/search': (context) => const MainLayout(initialIndex: 1),
          '/add': (context) => const MainLayout(initialIndex: 2),
          '/favorite': (context) => const MainLayout(initialIndex: 3),
          '/profile': (context) => const MainLayout(initialIndex: 4),
        },
      ),
    );
  }
}
