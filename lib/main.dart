import 'package:firebase_core/firebase_core.dart';
import 'package:skylab_mobile/view_models/home_view_model.dart';
import 'core/config/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'views/login_screen.dart';
import 'core/theme/theme_provider.dart';
import 'view_models/user_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: SkylabApp(),
    ),
  );
}

class SkylabApp extends StatelessWidget {
  const SkylabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Drone App',
          theme: themeProvider.themeData,
          home: LoginScreen(),
        );
      },
    );
  }
}