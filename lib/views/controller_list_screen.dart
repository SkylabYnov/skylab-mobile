import 'package:flutter/material.dart';

class ControllerListScreen extends StatefulWidget {
  const ControllerListScreen({super.key});

  @override
  State<ControllerListScreen> createState() => _ControllerListScreenState();
}

class _ControllerListScreenState extends State<ControllerListScreen> {
  final List<Map<String, dynamic>> controllers = [
    {'id': 'CTRL001', 'active': true},
    {'id': 'CTRL002', 'active': false},
    {'id': 'CTRL003', 'active': true},
  ];

  void toggleState(int index) {
    setState(() {
      controllers[index]['active'] = !controllers[index]['active'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controllers')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: controllers.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final controller = controllers[index];
          return ListTile(
            title: Text('ID: ${controller['id']}'),
            subtitle: Text('State: ${controller['active'] ? 'Active' : 'Inactive'}'),
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
                  child: Text(controller['active'] ? 'Deactivate' : 'Activate'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
