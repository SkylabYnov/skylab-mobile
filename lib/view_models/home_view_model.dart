import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_serial_communication/models/device_info.dart';
import 'package:skylab_mobile/services/serial_service.dart';

class HomeViewModel extends ChangeNotifier {
  final SerialService _serialService = SerialService();

  String _messageTitle = '';
  String _messageBody = '';

  String get messageTitle => _messageTitle;
  String get messageBody => _messageBody;

  set messageTitle(String value) {
    _messageTitle = value;
    notifyListeners();
  }

  set messageBody(String value) {
    _messageBody = value;
    notifyListeners();
  }

  Future<void> sendComposedMessage() async {
    if (_messageTitle.isEmpty || _messageBody.isEmpty) return;

    final json = { _messageTitle: _messageBody };
    await send(jsonEncode(json));
  }

  String _status = 'Not connected';
  String get status => _status;

  String _receivedData = '';
  String get receivedData => _receivedData;

  List<DeviceInfo> _availableDevices = [];
  List<DeviceInfo> get availableDevices => _availableDevices;

  DeviceInfo? _selectedDevice;
  DeviceInfo? get selectedDevice => _selectedDevice;
  set selectedDevice(DeviceInfo? device) {
    _selectedDevice = device;
    notifyListeners();
  }

  bool get isConnected => _serialService.isConnected;

  Future<void> loadDevices() async {
    _availableDevices = await _serialService.getAvailableDevices();
    notifyListeners();
  }

  Future<void> connect() async {
    if (_selectedDevice == null) return;
    bool ok = await _serialService.connect(_selectedDevice!);
    if (ok) {
      _status = 'Connected to ${_selectedDevice!.productName}';
      notifyListeners();

      _serialService
          .onMessageReceived()
          .cast<Uint8List>()
          .listen((data) {
        _receivedData += utf8.decode(data);
        notifyListeners();
      });

      _serialService
          .onConnectionChanged()
          .cast<bool>()
          .listen((connected) {
        if (!connected) {
          _status = 'Disconnected';
          notifyListeners();
        }
      });
    } else {
      _status = 'Connection failed';
      notifyListeners();
    }
  }

  Future<void> send(String message) async {
    String out = message.endsWith('\n') ? message : '$message\n';
    await _serialService.send(Uint8List.fromList(utf8.encode(out)));
  }

  Future<void> disconnect() async {
    await _serialService.disconnect();
    _status = 'Disconnected';
    notifyListeners();
  }

  void clearReceivedData() {
    _receivedData = '';
    notifyListeners();
  }
}
