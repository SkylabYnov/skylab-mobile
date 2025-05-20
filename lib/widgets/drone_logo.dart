import 'package:flutter/material.dart';

class DroneLogo extends StatelessWidget {
  final String title;
  
  const DroneLogo({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/icon-drone.png',
          height: 200,
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
