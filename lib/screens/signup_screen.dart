import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>{
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void signUn() async {
        User? user = await AuthService().signUp(emailController.text, passwordController.text);
        if (user != null) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign up failed")));
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text("Sign up")),
            body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                    children: [
                        TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
                        TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
                        SizedBox(height: 20),
                        ElevatedButton(onPressed: signUp, child: Text("Sign up")),
                        TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
                            child: Text("Already have an account? Login"),
                        ),
                    ],
                ),
            ),
        );
    }
}