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

  Future<void> _editControllerId(int index) async {
    final controller = controllers[index];
    final TextEditingController textController = TextEditingController(text: controller['id']);

    final newId = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Controller ID'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(labelText: 'Controller ID'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, textController.text), child: const Text('Save')),
        ],
      ),
    );

    if (newId != null && newId.isNotEmpty) {
      setState(() {
        controllers[index]['id'] = newId;
      });
    }
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
                  onPressed: () => _editControllerId(index),
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
