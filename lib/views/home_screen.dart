import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../core/theme/theme_provider.dart';
import 'login_screen.dart';
import '../views/dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? droneId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkDrone();
  }

  Future<void> checkDrone() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        setState(() {
          droneId = doc.data()!['droneId'];
          isLoading = false;
        });
      } else {
        setState(() {
          droneId = null;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            droneId != null
              ? Text("Your drone ID is: $droneId")
              : Column(
                  children: [
                    Text("No drone connected."),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => DroneControllerScreen()),
                        );
                      },
                      child: Text("Connect a drone"),
                    ),
                  ],
                ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
