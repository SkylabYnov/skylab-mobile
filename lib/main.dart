import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_serial_communication/flutter_serial_communication.dart';
import 'package:flutter_serial_communication/models/device_info.dart';

void main() => runApp(const LampControlApp());

class LampControlApp extends StatelessWidget {
  const LampControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LampControlPage(),
    );
  }
}

class LampControlPage extends StatefulWidget {
  const LampControlPage({super.key});

  @override
  _LampControlPageState createState() => _LampControlPageState();
}

class _LampControlPageState extends State<LampControlPage> {
  final FlutterSerialCommunication _serialCommunication = FlutterSerialCommunication();
  bool isConnected = false;
  List<DeviceInfo> connectedDevices = [];

  @override
  void initState() {
    super.initState();

    _serialCommunication
        .getSerialMessageListener()
        .receiveBroadcastStream()
        .listen((event) {
      debugPrint("Received: $event");
    });

    _serialCommunication
        .getDeviceConnectionListener()
        .receiveBroadcastStream()
        .listen((event) {
      setState(() {
        isConnected = event;
      });
    });
  }

  Future<void> _getAllConnectedDevices() async {
    List<DeviceInfo> devices = await _serialCommunication.getAvailableDevices();
    setState(() {
      connectedDevices = devices;
    });
  }

  Future<void> _connectDevice(DeviceInfo deviceInfo) async {
    bool connectionSuccess = await _serialCommunication.connect(deviceInfo, 9600);
    debugPrint("Connection success: $connectionSuccess");
  }

  Future<void> _disconnectDevice() async {
    await _serialCommunication.disconnect();
    setState(() {
      isConnected = false;
    });
  }

  Future<void> _sendCommand(String command) async {
    if (!isConnected) return;
    bool success = await _serialCommunication.write(Uint8List.fromList('${command.trim()}\n'.codeUnits));
    debugPrint("Command sent successfully: $success");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lamp Control (USB)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              isConnected ? 'ESP32 Connected' : 'ESP32 Not Connected',
              style: TextStyle(fontSize: 20, color: isConnected ? Colors.green : Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getAllConnectedDevices,
              child: const Text("Get Connected Devices"),
            ),
            const SizedBox(height: 20),
            ...connectedDevices.map((device) => Row(
              children: [
                Expanded(child: Text(device.productName)),
                ElevatedButton(
                  onPressed: () => _connectDevice(device),
                  child: const Text("Connect"),
                ),
              ],
            )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isConnected ? _disconnectDevice : null,
              child: const Text("Disconnect"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isConnected ? () => _sendCommand("ON") : null,
              child: const Text("Turn ON"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isConnected ? () => _sendCommand("OFF") : null,
              child: const Text("Turn OFF"),
            ),
          ],
        ),
      ),
    );
  }
}
