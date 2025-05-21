import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:skylab_mobile/services/auth_service.dart';
import 'package:skylab_mobile/view_models/user_view_model.dart';
import 'package:skylab_mobile/widgets/buttons/link_text_button.dart';
import 'package:skylab_mobile/widgets/buttons/primary_button.dart';
import 'package:skylab_mobile/widgets/app_logo.dart';
import 'package:skylab_mobile/views/login_screen.dart';
import 'package:skylab_mobile/views/onboarding_screen.dart';
import 'package:skylab_mobile/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppLogo(title: "Sign Up"),
                        SizedBox(height: 40),
                        CustomTextField(
                          controller: emailController,
                          labelText: "Email",
                        ),
                        CustomTextField(
                          controller: passwordController,
                          labelText: "Password",
                          obscureText: true,
                        ),
                        SizedBox(height: 20),
                        PrimaryButton(
                          child: Text("Sign Up"),
                          onPressed: () async {
                            String email = emailController.text.trim();
                            String password = passwordController.text.trim();

                            if (email.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Please fill in all fields")),
                              );
                              return;
                            }

                            bool success = await userViewModel.signUp(email, password);
                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Register failed")),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 16),
                        PrimaryButton(
                          onPressed: () async {
                            User? user = await _authService.signInWithGoogle();
                            if (user != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => OnboardingScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Google sign-in failed")),
                              );
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(FontAwesomeIcons.google, color: Colors.red),
                              SizedBox(width: 10),
                              Text("Sign up with Google"),
                            ],
                          ),
                        ),
                        Spacer(),
                        LinkTextButton(
                          text: "Already have an account? Login",
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
