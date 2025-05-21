import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skylab_mobile/widgets/buttons/link_text_button.dart';
import 'package:skylab_mobile/services/auth_service.dart';
import 'package:skylab_mobile/views/signup_screen.dart';
import 'package:skylab_mobile/views/onboarding_screen.dart';
import 'package:skylab_mobile/widgets/buttons/primary_button.dart';
import 'package:skylab_mobile/widgets/app_logo.dart';
import 'package:skylab_mobile/widgets/custom_text_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    User? user = await AuthService().signIn(
        emailController.text, passwordController.text);
    if (user != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AppLogo(title: "Login"),
                        const SizedBox(height: 40),

                        CustomTextField(
                          controller: emailController,
                          labelText: "Email",
                        ),
                        CustomTextField(
                          controller: passwordController,
                          labelText: "Password",
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),

                        PrimaryButton(
                          onPressed: login,
                          child: const Text("Login"),
                        ),
                        const SizedBox(height: 20),

                        PrimaryButton(
                          onPressed: () async {
                            User? user = await AuthService().signInWithGoogle();
                            if (user != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OnboardingScreen(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Google login failed")),
                              );
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(FontAwesomeIcons.google, color: Colors.red),
                              SizedBox(width: 10),
                              Text("Sign in with Google"),
                            ],
                          ),
                        ),

                        const Spacer(),

                        LinkTextButton(
                          text: "New to our app? Create an account",
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          ),
                        ),
                        const SizedBox(height: 10),
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
