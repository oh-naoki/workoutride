import 'package:audioplayers/audioplayers.dart';
import 'package:workoutride/domain/repository/workout_sound_player.dart';

/// ワークアウト中の効果音・BGM再生を担う Service（[WorkoutSoundPlayer] の実装）。
///
/// 1つの外部I/O（audioplayersプラグイン）を包む薄い窓口。状態を持たず、
/// 呼び出しは全て fire-and-forget（await しない）。
///
/// `AudioPlayer` はプラットフォームチャンネル（EventChannel）に同期的に
/// アクセスするため、Flutter バインディングが無い環境（flutter test 実行時
/// など）ではコンストラクタ呼び出し自体が例外を投げる。そのため生成を
/// 遅延させ、初回利用時に try/catch で包む。生成・再生いずれの失敗も
/// ワークアウト進行を止めてはならないため、常に無視して処理を継続する。
class WorkoutSoundPlayerImpl implements WorkoutSoundPlayer {
  static const _sfxBase = 'sounds/sfx';
  static const _bgmBase = 'sounds/bgm';

  AudioPlayer? _sfxPlayer;
  AudioPlayer? _bgmPlayer;

  AudioPlayer? _sfx() {
    final existing = _sfxPlayer;
    if (existing != null) return existing;
    try {
      final player = AudioPlayer(playerId: 'workout_sfx');
      player.audioCache.prefix = 'assets/$_sfxBase/';
      return _sfxPlayer = player;
    } catch (_) {
      return null;
    }
  }

  AudioPlayer? _bgm() {
    final existing = _bgmPlayer;
    if (existing != null) return existing;
    try {
      final player = AudioPlayer(playerId: 'workout_bgm');
      player.audioCache.prefix = 'assets/$_bgmBase/';
      player.setReleaseMode(ReleaseMode.loop);
      return _bgmPlayer = player;
    } catch (_) {
      return null;
    }
  }

  Future<void> _playSfx(String fileName) async {
    final player = _sfx();
    if (player == null) return;
    try {
      await player.play(AssetSource(fileName));
    } catch (_) {
      // デバイス側の再生失敗は無視する。効果音の再生失敗で
      // ワークアウト進行を止めてはならない。
    }
  }

  @override
  void playCountdownTick() => _playSfx('countdown_tick.wav');
  @override
  void playBlockTransition() => _playSfx('block_transition.wav');
  @override
  void playPowerTooHigh() => _playSfx('power_high_alert.wav');
  @override
  void playPowerTooLow() => _playSfx('power_low_alert.wav');
  @override
  void playPause() => _playSfx('pause_sound.wav');
  @override
  void playResume() => _playSfx('resume_sound.wav');
  @override
  void playWorkoutComplete() => _playSfx('workout_complete.wav');

  /// 控えめな音量でアンビエントBGMをループ再生する。
  @override
  Future<void> startAmbientLoop({double volume = 0.4}) async {
    final player = _bgm();
    if (player == null) return;
    try {
      await player.setVolume(volume);
      await player.play(AssetSource('ambient_loop.wav'));
    } catch (_) {
      // 同上：BGM再生失敗はワークアウト進行に影響させない。
    }
  }

  @override
  Future<void> stopAmbientLoop() async {
    final player = _bgmPlayer;
    if (player == null) return;
    try {
      await player.stop();
    } catch (_) {}
  }

  @override
  void dispose() {
    _sfxPlayer?.dispose();
    _bgmPlayer?.dispose();
  }
}
