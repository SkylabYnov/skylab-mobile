import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skylab_mobile/view_models/home_view_model.dart';
import 'package:flutter_serial_communication/models/device_info.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel()..loadDevices(),
      child: Scaffold(
        appBar: AppBar(title: Text("ESP32 Serial Communication")),
        body: Consumer<HomeViewModel>(
          builder: (context, vm, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Status: ${vm.status}", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),

                  // Liste des périphériques disponibles
                  DropdownButton<DeviceInfo>(
                    value: vm.availableDevices.isNotEmpty ? vm.availableDevices.first : null,
                    hint: Text("Select a device"),
                    items: vm.availableDevices.map((device) {
                      return DropdownMenuItem(
                        value: device,
                        child: Text(device.productName),
                      );
                    }).toList(),
                    onChanged: (selectedDevice) async {
                      if (selectedDevice != null) {
                        await vm.connect(selectedDevice);
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () async {
                      await vm.loadDevices();
                    },
                    child: Text("Refresh Devices"),
                  ),

                  ElevatedButton(
                    onPressed: vm.isConnected ? () => vm.send("Hello Amaury, comment vas-tu aujourd'hui ?") : null,
                    child: Text("Send Message"),
                  ),

                  ElevatedButton(
                    onPressed: vm.isConnected ? () => vm.disconnect() : null,
                    child: Text("Disconnect"),
                  ),

                  // Bouton pour effacer les messages reçus
                  ElevatedButton(
                    onPressed: vm.clearReceivedData,
                    child: Text("Clear Messages"),
                  ),

                  const SizedBox(height: 16),
                  Text("Messages received:", style: TextStyle(fontWeight: FontWeight.bold)),

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        child: SelectableText(
                          vm.receivedData.isNotEmpty
                              ? vm.receivedData
                              : "No data received yet.",
                          style: TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}