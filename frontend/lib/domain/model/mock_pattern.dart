/// 開発者メニューで選択するモックパワーデータのパターン。
///
/// パターンの「識別子」と「表示名」だけを持つドメインの値。
/// 実際のモックデータ生成ロジックは data 層（power_meter_data_source.dart の
/// MockPatternGenerator extension）が担う。
enum MockPattern {
  warmup(name: 'ウォームアップ'),
  interval(name: 'インターバル'),
  steady(name: 'ステディ'),
  cooldown(name: 'クールダウン');

  final String name;
  const MockPattern({required this.name});
}
