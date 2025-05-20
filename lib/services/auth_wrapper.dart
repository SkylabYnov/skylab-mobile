import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skylab_mobile/views/login_screen.dart';
import 'package:skylab_mobile/views/home_screen.dart';
import 'package:skylab_mobile/view_models/user_view_model.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        userViewModel.loadUser(); 

        if (userViewModel.userModel != null) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

