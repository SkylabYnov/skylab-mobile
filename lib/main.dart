import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skylab_mobile/core/config/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:skylab_mobile/core/theme/theme_provider.dart';
import 'package:skylab_mobile/services/auth_wrapper.dart';
import 'package:skylab_mobile/view_models/user_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserViewModel()), 
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
          title: 'Skylab',
          theme: themeProvider.themeData,
          home: AuthWrapper(),
        );
      },
    );
  }
}