import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_serial_communication/flutter_serial_communication.dart';
import 'package:flutter_serial_communication/models/device_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP32 USB Slider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SliderPage(),
    );
  }
}

class SliderPage extends StatefulWidget {
  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  final FlutterSerialCommunication _serialCommunication = FlutterSerialCommunication();
  List<DeviceInfo> connectedDevices = [];
  bool isConnected = false;
  double _sliderValue = 0;
  List<String> receivedMessages = [];

  @override
  void initState() {
    super.initState();

    // Listener for incoming messages
    _serialCommunication
        .getSerialMessageListener()
        .receiveBroadcastStream()
        .listen((event) {
      try {
        final String message = String.fromCharCodes(event);
        setState(() {
          receivedMessages.add(message);
        });
      } catch (e) {
        debugPrint("Error processing received data: $e");
      }
    });

    // Listener for device connection status
    _serialCommunication
        .getDeviceConnectionListener()
        .receiveBroadcastStream()
        .listen((event) {
      setState(() {
        isConnected = event;
      });
    });

    _getAllConnectedDevices();
  }

  Future<void> _getAllConnectedDevices() async {
    List<DeviceInfo> devices = await _serialCommunication.getAvailableDevices();
    setState(() {
      connectedDevices = devices;
    });

    if (connectedDevices.isNotEmpty) {
      await _connectDevice(connectedDevices.first);
    } else {
      debugPrint("Aucun périphérique connecté.");
    }
  }

  Future<void> _connectDevice(DeviceInfo deviceInfo) async {
    bool connectionSuccess = await _serialCommunication.connect(deviceInfo, 115200);
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
    debugPrint("Command ($command) sent successfully: $success");
  }

  Future<void> _sendValueToESP32(int value) async {
    await _sendCommand(value.toString());
  }

  @override
  void dispose() {
    _disconnectDevice();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ESP32 USB Slider'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Valeur: ${_sliderValue.toInt()}',
            style: TextStyle(fontSize: 24),
          ),
          Slider(
            value: _sliderValue,
            min: 0,
            max: 1023,
            divisions: 1023,
            label: _sliderValue.toInt().toString(),
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
              _sendValueToESP32(value.toInt());
            },
          ),
          SizedBox(height: 20),
          isConnected
              ? Text("Périphérique connecté", style: TextStyle(color: Colors.green))
              : Text("Périphérique déconnecté", style: TextStyle(color: Colors.red)),
          ElevatedButton(
            onPressed: isConnected ? _disconnectDevice : null,
            child: Text("Déconnecter"),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: receivedMessages.length,
              itemBuilder: (context, index) {
                return Text(
                  receivedMessages[index],
                  style: TextStyle(fontSize: 16),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}