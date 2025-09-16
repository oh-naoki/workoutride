import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BleConnector {
  static const String _deviceIdKey = 'last_connected_device_id';
  final SharedPreferences _sharedPreferences;

  BleConnector(this._sharedPreferences);

  Future<void> initialize() async {
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
  }

  Stream<List<ScanResult>> scan() {
    final StreamController<List<ScanResult>> controller = StreamController<List<ScanResult>>();
    final Set<String> seenDevices = {}; // デバイスのIDを保持するSet
    final List<ScanResult> scanResults = []; // スキャン結果を保持するList

    FlutterBluePlus.onScanResults.listen((results) {
      for (var result in results) {
        final String deviceId = result.device.remoteId.toString();
        // 既に見つかったデバイスかどうかを確認
        if (!seenDevices.contains(deviceId)) {
          seenDevices.add(deviceId); // 新しいデバイスを記録
          scanResults.add(result); // スキャン結果をListに追加
          controller.add(List.unmodifiable(scanResults)); // StreamにListのスナップショットを追加
        }
      }
    }, onError: (e) {
      controller.addError(e); // エラーが発生した場合、Streamにエラーを追加
    });

    // システムデバイスを取得してスキャンを開始します。
    FlutterBluePlus.systemDevices([Guid("180f")]);
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 300));

    return controller.stream;
  }

  Future<void> connect(String deviceId) async {
    // deviceIdを永続化
    await _sharedPreferences.setString(_deviceIdKey, deviceId);
    
    final device = BluetoothDevice.fromId(deviceId);
    await device.connect();
  }

  /// 保存されたデバイスIDを取得
  Future<String?> getSavedDeviceId() async {
    return _sharedPreferences.getString(_deviceIdKey);
  }

  /// 保存されたデバイスに自動接続を試行
  Future<bool> autoConnect() async {
    try {
      final savedDeviceId = await getSavedDeviceId();
      if (savedDeviceId == null) {
        return false; // 保存されたデバイスIDがない
      }

      final device = BluetoothDevice.fromId(savedDeviceId);
      
      // 接続を試行
      await device.connect(timeout: const Duration(seconds: 10));
      
      // 接続状態を確認
      final isConnected = device.isConnected;
      if (!isConnected) {
        return false;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// デバイスの切断
  Future<void> disconnect() async {
    try {
      final savedDeviceId = await getSavedDeviceId();
      if (savedDeviceId != null) {
        final device = BluetoothDevice.fromId(savedDeviceId);
        await device.disconnect();
      }
    } catch (e) {
      // 切断エラーは無視
    }
  }

  // notification の登録とデータを返したい
  Stream<List<int>> notify(String uuid) async* {
    try {
      // SharedPreferencesからdeviceIdを取得
      final savedDeviceId = _sharedPreferences.getString(_deviceIdKey);
      
      if (savedDeviceId == null) {
        throw Exception('デバイスが接続されていません');
      }

      final device = BluetoothDevice.fromId(savedDeviceId);
      
      // 接続を待機
      await device.connect();
      
      // サービスディスカバリーを待機
      final services = await device.discoverServices();
      
      bool characteristicFound = false;
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid == Guid(uuid)) {
            characteristicFound = true;
            await characteristic.setNotifyValue(true);
            await for (final value in characteristic.onValueReceived) {
              yield value;
            }
          }
        }
      }
      
      if (!characteristicFound) {
        throw Exception('指定されたUUIDのキャラクタリスティックが見つかりませんでした');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
