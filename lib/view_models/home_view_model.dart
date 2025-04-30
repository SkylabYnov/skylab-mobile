import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:skylab_mobile/services/serial_service.dart';
import 'package:flutter_serial_communication/models/device_info.dart';

class HomeViewModel extends ChangeNotifier {
  final SerialService _serialService = SerialService();

  String _status = 'Not connected';
  String _receivedData = '';  // Pour afficher les données reçues
  List<DeviceInfo> _availableDevices = [];

  String get status => _status;
  String get receivedData => _receivedData;
  List<DeviceInfo> get availableDevices => _availableDevices;
  bool get isConnected => _serialService.isConnected;

  Future<void> loadDevices() async {
    _availableDevices = await _serialService.getAvailableDevices();
    notifyListeners();
  }

  Future<void> connect(DeviceInfo device) async {
    bool ok = await _serialService.connect(device);
    if (ok) {
      _status = 'Connected to ${device.productName}';

      _serialService.onMessageReceived().listen((event) {
        _receivedData += String.fromCharCodes(event);  // Conversion des bytes en chaîne ASCII
        notifyListeners();
      });

      _serialService.onConnectionChanged().listen((connected) {
        if (!connected) {
          _status = 'Disconnected';
          notifyListeners();
        }
      });
    } else {
      _status = 'Connection failed';
    }
    notifyListeners();
  }

  Future<void> disconnect() async {
    await _serialService.disconnect();
    _status = 'Disconnected';
    notifyListeners();
  }

  Future<void> send(String message) async {
    await _serialService.send(Uint8List.fromList(message.codeUnits));
  }

  void clearReceivedData() {
    _receivedData = '';  // Effacer les messages reçus
    notifyListeners();
  }

  @override
  void dispose() {
    _serialService.disconnect();
    super.dispose();
  }
}