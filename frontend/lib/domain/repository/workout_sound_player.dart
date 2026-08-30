/// ワークアウト中の効果音・BGM 再生のポート（外部 I/O の抽象）。
///
/// ViewModel はこの IF だけを見る。実装（audioplayers を叩く具象）は
/// `data/audio/workout_sound_player_impl.dart` にあり、ui → data の
/// 依存を作らないための境界としてこの IF を挟んでいる。
///
/// 再生の失敗でワークアウト進行を止めてはならないため、実装側は例外を
/// 握りつぶす契約とする。呼び出し側はエラー処理を書かなくてよい。
abstract class WorkoutSoundPlayer {
  void playCountdownTick();
  void playBlockTransition();
  void playPowerTooHigh();
  void playPowerTooLow();
  void playPause();
  void playResume();
  void playWorkoutComplete();

  /// 控えめな音量でアンビエント BGM をループ再生する。
  Future<void> startAmbientLoop({double volume = 0.4});

  Future<void> stopAmbientLoop();

  void dispose();
}
