import 'package:flutter/material.dart';

/// アプリのブランドカラー（アイコンのオレンジに合わせている）
class AppColors {
  const AppColors._();

  /// メインのブランドカラー
  static const Color brand = Color(0xFFFF6A13);

  /// ブランドカラーの濃いトーン（グラデーションやAppBarの下地）
  static const Color brandDark = Color(0xFFE04E00);

  /// 画面全体の背景
  static const Color background = Color(0xFF121212);

  /// カードなどの一段明るい面
  static const Color surface = Color(0xFF1E1E1E);

  /// さらに明るい面（ボトムナビなど）
  static const Color surfaceHigh = Color(0xFF2C2C2C);
}
