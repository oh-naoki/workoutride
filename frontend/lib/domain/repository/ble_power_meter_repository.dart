import 'package:workoutride/domain/model/device_scan_result.dart';

/// パワーメーター（BLE デバイス）の探索と接続を扱うリポジトリ。
///
/// 他の3ドメイン（workout / auth / user_profile）と同様に、外部 I/O は
/// このインターフェース越しにだけ触る。実装は
/// `data/repository/ble_power_meter_repository_impl.dart`。
///
/// 以前は ViewModel が `BleConnector`（data 層の Service）を包んだだけの
/// 薄い UseCase を経由しており、BLE だけが Repository 層を持たない非対称な
/// 構造になっていた（docs/architecture.md §7 A2）。
abstract class BlePowerMeterRepository {
  /// BLE アダプタを利用可能な状態にする（Android では必要なら電源を入れる）。
  Future<void> initialize();

  /// 周辺のパワーメーターを探索する。
  ///
  /// 発見済みデバイスを積み上げたリストを、見つかるたびに流す。
  /// Cycling Power Service を持つデバイスだけが対象。
  Stream<List<DeviceScanResult>> scanDevices();

  /// 指定デバイスに接続し、次回の自動接続先として記憶する。
  Future<void> connect(String deviceId);

  /// 記憶済みのデバイスへ自動接続を試みる。成否を返す。
  Future<bool> autoConnect();

  /// 記憶済みのデバイス ID。未接続なら null。
  Future<String?> getSavedDeviceId();

  /// 接続中のデバイスを切断する。
  Future<void> disconnect();
}
