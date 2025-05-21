import 'package:flutter/material.dart';
import 'package:skylab_mobile/views/settings_screen.dart';

class DroneControllerScreen extends StatelessWidget {
  const DroneControllerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Skylab Dashboard"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // ⬅️ Back button
          onPressed: () {
            Navigator.pop(context); // Go back to previous screen
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: const Center(child: Text("Drone", style: TextStyle(fontSize: 18))),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: const Center(child: Text("Controller", style: TextStyle(fontSize: 18))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
