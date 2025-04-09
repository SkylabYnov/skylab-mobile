import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  final VoidCallback onTap;

  const AuthFooter({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Text(
        "New to our app? Create an account",
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 14,
        ),
      ),
    );
  }
}
