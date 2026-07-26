import 'package:workoutride/data/ble_connector.dart';
import 'package:workoutride/domain/model/mock_pattern.dart';

abstract class PowerMeterDataSource {
  Stream<List<int>> getRawData();
}

class BlePowerMeterDataSource implements PowerMeterDataSource {
  final BleConnector _bleConnector;

  BlePowerMeterDataSource(this._bleConnector);

  @override
  Stream<List<int>> getRawData() => _bleConnector.notify("2A63");
}

/// MockPattern（ドメインの値）に対して、モックの生パワーメーターデータを
/// 生成するロジックを与える data 層の extension。
/// domain には識別子・表示名のみを置き、生成ロジックはここ（data）に閉じる。
extension MockPatternGenerator on MockPattern {
  List<int> generateData(int count) {
    switch (this) {
      case MockPattern.warmup:
        return _generateWarmupData(count);
      case MockPattern.interval:
        return _generateIntervalData(count);
      case MockPattern.steady:
        return _generateSteadyData(count);
      case MockPattern.cooldown:
        return _generateCooldownData(count);
    }
  }
}

// ウォームアップパターン: 徐々にパワーが上昇
List<int> _generateWarmupData(int count) {
  // より滑らかな上昇カーブ（100Wから200Wまで3分かけて上昇）
  final progress = (count % 180) / 180.0; // 3分で1サイクル
  final power = 100 + (100 * progress).toInt();
  final cadence = count; // 累積回転数として使用
  return _createPowerMeterData(power, cadence);
}

// インターバルパターン: 高強度と低強度を繰り返す
List<int> _generateIntervalData(int count) {
  // 30秒間隔でのインターバル（より滑らかな遷移）
  final cyclePosition = count % 30; // 30秒で1サイクル
  final baseIntensity = count ~/ 30 % 2 == 0; // 30秒ごとに切り替え

  int power;
  if (cyclePosition < 5) {
    // 5秒間の遷移時間
    // 低強度から高強度、または高強度から低強度への遷移
    final transitionProgress = cyclePosition / 5.0;
    power = baseIntensity
        ? (150 + (100 * transitionProgress)).toInt() // 150W → 250W
        : (250 - (100 * transitionProgress)).toInt(); // 250W → 150W
  } else {
    // 一定強度の維持
    power = baseIntensity ? 250 : 150;
  }

  final cadence = count; // 累積回転数として使用
  return _createPowerMeterData(power, cadence);
}

// ステディパターン: 一定のパワーを維持（わずかな変動あり）
List<int> _generateSteadyData(int count) {
  // 180W±10Wの範囲でわずかに変動
  final variation = (count % 10) - 5; // -5から+5の変動
  final power = 180 + variation;
  final cadence = count; // 累積回転数として使用
  return _createPowerMeterData(power, cadence);
}

// クールダウンパターン: 徐々にパワーが低下
List<int> _generateCooldownData(int count) {
  // より滑らかな下降カーブ（200Wから100Wまで3分かけて下降）
  final progress = (count % 180) / 180.0; // 3分で1サイクル
  final power = 200 - (100 * progress).toInt();
  final cadence = count; // 累積回転数として使用
  return _createPowerMeterData(power, cadence);
}

// BLEデータフォーマットに合わせてデータを生成
List<int> _createPowerMeterData(int power, int cadence) {
  // フラグの設定（Crank Revolution Dataを含むことを示す）
  const flags = 0x020; // Bit 5 を立てる（クランク回転データあり）

  // パワーを16ビットの整数として表現
  final powerBytes = power.toUnsigned(16);

  // クランク回転データ
  final cumulativeCrankRevolutions = cadence; // 累積回転数をそのまま使用
  final currentCrankEventTime =
      (cadence * 1024) % 65536; // 時間も累積的に増加（65536でラップアラウンド）

  // BLEデータフォーマットに合わせてバイト配列を作成
  return [
    flags & 0xFF, // フラグ（下位バイト）
    (flags >> 8) & 0xFF, // フラグ（上位バイト）
    powerBytes & 0xFF, // パワー（下位バイト）
    (powerBytes >> 8) & 0xFF, // パワー（上位バイト）
    cumulativeCrankRevolutions & 0xFF, // クランク回転数（下位バイト）
    (cumulativeCrankRevolutions >> 8) & 0xFF, // クランク回転数（上位バイト）
    currentCrankEventTime & 0xFF, // イベント時間（下位バイト）
    (currentCrankEventTime >> 8) & 0xFF, // イベント時間（上位バイト）
  ];
}

class MockPowerMeterDataSource implements PowerMeterDataSource {
  final MockPattern pattern;

  MockPowerMeterDataSource(this.pattern);

  @override
  Stream<List<int>> getRawData() {
    return Stream.periodic(const Duration(seconds: 1), (count) {
      return pattern.generateData(count);
    });
  }
}
