import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_serial_communication/flutter_serial_communication.dart';
import 'package:flutter_serial_communication/models/device_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP32 RGB Controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RGBControllerPage(),
    );
  }
}

class RGBControllerPage extends StatefulWidget {
  @override
  _RGBControllerPageState createState() => _RGBControllerPageState();
}

class _RGBControllerPageState extends State<RGBControllerPage> {
  final FlutterSerialCommunication _serialCommunication = FlutterSerialCommunication();
  List<DeviceInfo> connectedDevices = [];
  bool isConnected = false;
  Color _selectedColor = Colors.black;

  @override
  void initState() {
    super.initState();

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
    bool success = await _serialCommunication.write(Uint8List.fromList('${command.trim()};'.codeUnits));
    debugPrint("Command ($command) sent successfully: $success");
  }

  Future<void> _sendColorToESP32(Color color) async {
    String rgbCommand = "${color.red},${color.green},${color.blue}";
    await _sendCommand(rgbCommand);
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
        title: Text('ESP32 RGB Controller'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Couleur sélectionnée',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _showColorPicker(context),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: _selectedColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isConnected ? () => _sendColorToESP32(_selectedColor) : null,
              child: Text("Envoyer la couleur"),
            ),
            SizedBox(height: 20),
            isConnected
                ? Text("Périphérique connecté", style: TextStyle(color: Colors.green))
                : Text("Périphérique déconnecté", style: TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: isConnected ? _disconnectDevice : null,
              child: Text("Déconnecter"),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choisissez une couleur'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}
