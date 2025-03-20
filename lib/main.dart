import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'views/login_screen.dart';
import 'views/home_screen.dart';
import 'core/theme/theme_provider.dart';
import 'view_models/user_view_model.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => UserViewModel()), 
      ],
      child: SkyLabApp(),
    ),
  );

  runApp(const SkyLabApp());
}

class SkyLabApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}