/// パワーメーターの生データ（BLE の Cycling Power Measurement バイト列）を
/// 供給するポート。
///
/// 実装は `data/power_meter_data_source.dart` に2種類ある:
/// - `BlePowerMeterDataSource` … 実機の BLE 通知を購読する
/// - `MockPowerMeterDataSource` … 開発用の擬似データを生成する
///
/// バイト列のままなのは、パース（フラグ判定・クランク回転数からのケイデンス
/// 算出）を [GetPowerMeterDataUseCase] が状態を持ちながら行っているため。
/// ここでポートを domain 側に置くことで、UseCase が data 層を import せずに
/// 済むようにしている（docs/architecture.md §3 黄金律）。
abstract class PowerMeterRawDataSource {
  Stream<List<int>> getRawData();
}
