import 'package:freezed_annotation/freezed_annotation.dart';

part 'power_meter_data.freezed.dart';

@freezed
class PowerMeterData with _$PowerMeterData {
  const factory PowerMeterData({
    required int power,
    required int cadence,
  }) = _PowerMeterData;
}
