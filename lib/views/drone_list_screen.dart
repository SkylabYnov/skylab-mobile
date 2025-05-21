import 'package:flutter/material.dart';

class DroneListScreen extends StatefulWidget {
  const DroneListScreen({super.key});

  @override
  State<DroneListScreen> createState() => _DroneListScreenState();
}

class _DroneListScreenState extends State<DroneListScreen> {
  final List<Map<String, dynamic>> drones = [
    {'id': 'DR001', 'active': true},
    {'id': 'DR002', 'active': false},
    {'id': 'DR003', 'active': true},
  ];

  void toggleState(int index) {
    setState(() {
      drones[index]['active'] = !drones[index]['active'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drones')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: drones.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final drone = drones[index];
          return ListTile(
            title: Text('ID: ${drone['id']}'),
            subtitle: Text('State: ${drone['active'] ? 'Active' : 'Inactive'}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                  },
                ),
                ElevatedButton(
                  onPressed: () => toggleState(index),
                  child: Text(drone['active'] ? 'Deactivate' : 'Activate'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
