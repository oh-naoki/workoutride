import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'power_zone_analyzer.g.dart';

@riverpod
PowerZoneAnalyzer powerZoneAnalyzer(PowerZoneAnalyzerRef ref) {
  return PowerZoneAnalyzer();
}

class PowerZoneAnalyzer {
  static const double _tolerancePercentage = 0.1; // 10%の許容範囲

  bool isInTargetZone(int currentPower, int targetPower) {
    if (targetPower == 0) return true;

    final double lowerBound = targetPower * (1 - _tolerancePercentage);
    final double upperBound = targetPower * (1 + _tolerancePercentage);

    return currentPower >= lowerBound && currentPower <= upperBound;
  }

  bool isAboveTargetZone(int currentPower, int targetPower) {
    if (targetPower == 0) return false;

    final double upperBound = targetPower * (1 + _tolerancePercentage);
    return currentPower > upperBound;
  }

  bool isBelowTargetZone(int currentPower, int targetPower) {
    if (targetPower == 0) return false;

    final double lowerBound = targetPower * (1 - _tolerancePercentage);
    return currentPower < lowerBound;
  }
} 