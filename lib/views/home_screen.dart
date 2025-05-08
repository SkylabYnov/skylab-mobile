import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skylab_mobile/view_models/home_view_model.dart';
import 'package:flutter_serial_communication/models/device_info.dart';
import 'dart:convert';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel()..loadDevices(),
      child: Scaffold(
        appBar: AppBar(title: const Text("ESP32 Serial Communication")),
        body: const _HomeContent(),
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent({Key? key}) : super(key: key);

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final TextEditingController _msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Status: ${vm.status}", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),


          DropdownButton<DeviceInfo>(
            isExpanded: true,
            hint: const Text('Sélectionnez un appareil'),
            value: vm.selectedDevice,
            items: vm.availableDevices.map((device) {
              return DropdownMenuItem(
                value: device,
                child: Text(device.productName),
              );
            }).toList(),
            onChanged: vm.isConnected
                ? null
                : (device) {
              vm.selectedDevice = device;
            },
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: vm.isConnected || vm.selectedDevice == null
                ? null
                : vm.connect,
            child: const Text('Connecter'),
          ),

          const SizedBox(height: 16),

          TextField(
            decoration: const InputDecoration(labelText: 'Titre (clé JSON)'),
            onChanged: (value) => vm.messageTitle = value,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Message (valeur JSON)'),
            onChanged: (value) => vm.messageBody = value,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: vm.isConnected && vm.messageTitle.isNotEmpty && vm.messageBody.isNotEmpty
                ? vm.sendComposedMessage
                : null,
            child: const Text("Envoyer le message"),
          ),


          const SizedBox(height: 8),



          const SizedBox(height: 16),


          Row(
            children: [
              ElevatedButton(
                onPressed: vm.isConnected ? vm.disconnect : null,
                child: const Text("Disconnect"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: vm.clearReceivedData,
                child: const Text("Clear Messages"),
              ),
            ],
          ),

          const Divider(height: 32),


          const Text("Messages received:",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  vm.receivedData.isNotEmpty
                      ? vm.receivedData
                      : "No data received yet.",
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }
}
