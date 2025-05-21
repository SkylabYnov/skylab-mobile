import 'package:flutter/material.dart';
import 'package:skylab_mobile/views/settings_screen.dart';
import 'package:skylab_mobile/views/drone_list_screen.dart';
import 'package:skylab_mobile/views/controller_list_screen.dart';

class DroneControllerScreen extends StatelessWidget {
  const DroneControllerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Skylab Dashboard"),
        leading: IconButton(
 feature/google-login
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);

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

              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DroneListScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: const Center(
                    child: Text("Drone", style: TextStyle(fontSize: 18)),
                  ),
                ),

              ),
            ),
            const SizedBox(height: 16),
            Expanded(

              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ControllerListScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: const Center(
                    child: Text("Controller", style: TextStyle(fontSize: 18)),
                  ),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
