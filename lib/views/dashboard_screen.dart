import 'package:flutter/material.dart';
import 'package:skylab_mobile/views/settings_screen.dart';


class DroneControllerScreen extends StatefulWidget {
  @override
  _DroneControllerScreenState createState() => _DroneControllerScreenState();
}

class _DroneControllerScreenState extends State<DroneControllerScreen> {
  int _selectedIndex = 0;

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Center(child: Text("Drone", style: TextStyle(fontSize: 18))),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Center(child: Text("Controller", style: TextStyle(fontSize: 18))),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Skylab Dashboard"),
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            // Navigate to account settings
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.airplanemode_active),
            label: 'Drone',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Controller',
          ),
        ],
      ),
    );
  }
}
