import 'package:firebase_core/firebase_core.dart';
import 'core/config/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'views/login_screen.dart';
import 'core/theme/theme_provider.dart';
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Drone App',
          theme: themeProvider.themeData,
          home: HomeScreen(),
        );
      },
    );
  }
}
