import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ble_connector.g.dart';

@riverpod
BleConnector bleConnector(BleConnectorRef ref) {
  return BleConnector();
}

class BleConnector {
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
    // TODO: deviceId を永続化する
    final device = BluetoothDevice.fromId(deviceId);
    await device.connect();
  }

  // notification の登録とデータを返したい
  Stream<List<int>> notify(String deviceId, Guid uuid) {
    final StreamController<List<int>> controller = StreamController<List<int>>();
    final device = BluetoothDevice.fromId(deviceId);
    device.connect();
    device.discoverServices().then((services) {
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid == uuid) {
            characteristic.setNotifyValue(true);
            characteristic.onValueReceived.listen((value) {
              controller.add(value);
            });
          }
        }
      }
    });
    return controller.stream;
  }
}
