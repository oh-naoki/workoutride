import 'package:workoutride/data/power_meter_data_source.dart';
import 'package:workoutride/domain/model/power_meter_data.dart';

class GetPowerMeterDataUseCase {
  final PowerMeterDataSource _powerMeterDataSource;

  /// 時刻取得関数（テストから差し替え可能）
  final DateTime Function() _now;

  /// 新しいクランクイベントがこの時間来なければ停止とみなしてケイデンスを0にする
  static const Duration _cadenceStaleThreshold = Duration(seconds: 3);

  int lastCrankRevolutions = 0;
  int lastCrankEventTime = 0;

  /// クランクデータを一度でも受信したか（初回パケットの誤差分計算を防ぐ）
  bool _hasPreviousCrankData = false;

  /// 直近に算出したケイデンス（新しいクランクイベントが無い通知で保持する）
  int _lastCadence = 0;

  /// 最後に「新しいクランクイベント」を観測した実時刻
  DateTime? _lastCrankEventAt;

  GetPowerMeterDataUseCase(
    this._powerMeterDataSource, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  Stream<PowerMeterData> call() {
    return _powerMeterDataSource.getRawData().map((value) {
      return processData(value);
    });
  }

  PowerMeterData processData(List<int> value) {
    if (value.isEmpty || value.length < 4) {  // 最低でもフラグとパワーが必要
      return PowerMeterData(power: 0, cadence: _lastCadence);
    }

    // Flags の最初の 2 バイトを取得
    int flags = (value[1] << 8) | value[0];
    int index = 2; // データ読み取りの開始位置（フラグの後）

    // Instantaneous Power (必須フィールド, 2 バイト)
    int instantaneousPower = (value[index + 1] << 8) | value[index];
    index += 2;

    // Pedal Power Balance (任意, Flag の Bit 0 が立っている場合)
    if ((flags & 0x001) != 0 && value.length > index) {
      index += 1;
    }

    // Crank Revolution Data (任意, Flag の Bit 5 が立っている場合)
    double crankRpm = _lastCadence.toDouble();
    if ((flags & 0x020) != 0 && value.length >= index + 4) {
      int cumulativeCrankRevolutions = (value[index + 1] << 8) | value[index];
      index += 2;
      int currentCrankEventTime = (value[index + 1] << 8) | value[index];

      // currentCrankEventTime / cumulativeCrankRevolutions は 16bit 値で
      // ラップアラウンドするため、差分は 16bit マスクを取る
      // （currentCrankEventTime は 1/1024 秒単位で約 64 秒ごとに一周する）
      int timeDiff = (currentCrankEventTime - lastCrankEventTime) & 0xFFFF;
      int revDiff = (cumulativeCrankRevolutions - lastCrankRevolutions) & 0xFFFF;

      final now = _now();
      if (!_hasPreviousCrankData) {
        // 初回はまだ差分を計算できない（累積値の基準が不明なため）
        crankRpm = 0;
      } else if (revDiff > 0 && timeDiff > 0) {
        // 新しいクランクイベントあり → ケイデンスを算出
        crankRpm = revDiff * 60 / (timeDiff / 1024);
        _lastCrankEventAt = now;
      } else {
        // 新しいクランクイベントが無い通知
        // （デバイスがクランク周期より速く notify する等で頻発する）
        if (_lastCrankEventAt == null ||
            now.difference(_lastCrankEventAt!) >= _cadenceStaleThreshold) {
          // 一定時間イベントが無ければ停止とみなす
          crankRpm = 0;
        } else {
          // 直前のケイデンスを保持し、平均値のディップ（一瞬だけ低下）を防ぐ
          crankRpm = _lastCadence.toDouble();
        }
      }

      lastCrankEventTime = currentCrankEventTime;
      lastCrankRevolutions = cumulativeCrankRevolutions;
      _hasPreviousCrankData = true;
    }

    _lastCadence = crankRpm.toInt();

    return PowerMeterData(
      power: instantaneousPower,
      cadence: _lastCadence,
    );
  }
}
