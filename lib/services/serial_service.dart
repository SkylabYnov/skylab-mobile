import 'dart:typed_data';
import 'package:flutter_serial_communication/flutter_serial_communication.dart';
import 'package:flutter_serial_communication/models/device_info.dart';

class SerialService {
  final FlutterSerialCommunication _serial = FlutterSerialCommunication();

  List<DeviceInfo> _devices = [];
  DeviceInfo? _connectedDevice;
  bool isConnected = false;

  Future<List<DeviceInfo>> getAvailableDevices() async {
    _devices = await _serial.getAvailableDevices();
    return _devices;
  }

  Future<bool> connect(DeviceInfo device) async {
    bool success = await _serial.connect(device, 115200);
    if (success) {
      _connectedDevice = device;
      isConnected = true;
    }
    return success;
  }

  Future<void> disconnect() async {
    await _serial.disconnect();
    isConnected = false;
  }

  Future<bool> send(Uint8List data) async {
    if (!isConnected) return false;
    return await _serial.write(data);
  }

  Stream<dynamic> onMessageReceived() {
    return _serial.getSerialMessageListener().receiveBroadcastStream();
  }

  Stream<dynamic> onConnectionChanged() {
    return _serial.getDeviceConnectionListener().receiveBroadcastStream();
  }

  DeviceInfo? get connectedDevice => _connectedDevice;
}