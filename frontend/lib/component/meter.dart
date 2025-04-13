import 'dart:math';

import 'package:flutter/material.dart';

class Meter extends StatelessWidget {
  const Meter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _MeterPainter(),
        ),
      ),
    );
  }
}

class _MeterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // ドーナツの中心点と半径を計算
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double outerRadius = size.width / 2;
    final double innerRadius = size.width / 4;

    // ドーナツ形状のパスを作成
    final Path donutPath = _createDonutPath(center, outerRadius, innerRadius);

    // ハの字形状でドーナツを切り取る
    final Path finalPath = _cutDonutWithHaShape(center, outerRadius, donutPath);

    // ドーナツ形状を描画
    final Paint donutPaint = Paint()
      ..color = const Color(0xFFDB4040)
      ..style = PaintingStyle.fill;
    canvas.drawPath(finalPath, donutPaint);

    // 角度の計算と線の描画
    const double position = 0.6; // 0から1の間の値

    // 弧を描画
    _drawArcAtPosition(canvas, center, innerRadius, outerRadius, position);

    // 線を描画
    _drawIndicatorLine(canvas, center, innerRadius, outerRadius, position);

    _drawCenteredText(canvas, center);
  }

  Path _createDonutPath(Offset center, double outerRadius, double innerRadius) {
    final Path outerCircle = Path()..addOval(Rect.fromCircle(center: center, radius: outerRadius));

    final Path innerCircle = Path()..addOval(Rect.fromCircle(center: center, radius: innerRadius));

    return Path.combine(PathOperation.difference, outerCircle, innerCircle);
  }

  Path _cutDonutWithHaShape(Offset center, double outerRadius, Path donutPath) {
    final double bottomY = center.dy + outerRadius;
    final double topY = center.dy;
    final double leftX = center.dx - outerRadius;
    final double rightX = center.dx + outerRadius;

    final Path haShape = Path()
      ..moveTo(center.dx, topY)
      ..lineTo(leftX, bottomY)
      ..lineTo(rightX, bottomY)
      ..close();

    return Path.combine(PathOperation.difference, donutPath, haShape);
  }

  void _drawIndicatorLine(Canvas canvas, Offset center, double innerRadius, double outerRadius, double position) {
    // 左下と右下の座標
    final double leftX = center.dx - outerRadius;
    final double rightX = center.dx + outerRadius;
    final double bottomY = center.dy + outerRadius;

    final Offset leftBottom = Offset(leftX, bottomY);
    final Offset rightBottom = Offset(rightX, bottomY);

    // 左端と右端の角度を計算
    final double startAngle = atan2(leftBottom.dy - center.dy, leftBottom.dx - center.dx);
    final double endAngle = atan2(rightBottom.dy - center.dy, rightBottom.dx - center.dx);

    // 角度の差を計算
    double angleDifference;
    if (endAngle <= startAngle) {
      angleDifference = endAngle + 2 * pi - startAngle;
    } else {
      angleDifference = endAngle - startAngle;
    }

    // 角度を計算（時計回りに増加）
    double angle = startAngle + angleDifference * position;

    // 角度が2πを超える場合に対応
    if (angle > 2 * pi) {
      angle -= 2 * pi;
    }

    // 線の始点と終点を計算
    final Offset lineStart = Offset(
      center.dx + innerRadius * cos(angle),
      center.dy + innerRadius * sin(angle),
    );

    final Offset lineEnd = Offset(
      center.dx + outerRadius * cos(angle),
      center.dy + outerRadius * sin(angle),
    );

    // 線を描画
    final Paint linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(lineStart, lineEnd, linePaint);
  }

  void _drawArcAtPosition(Canvas canvas, Offset center, double innerRadius, double outerRadius, double position) {
    // 角度幅（±0.05）を設定
    const double angleWidthFraction = 0.05;

    // 左下と右下の座標
    final double leftX = center.dx - outerRadius;
    final double rightX = center.dx + outerRadius;
    final double bottomY = center.dy + outerRadius;

    final Offset leftBottom = Offset(leftX, bottomY);
    final Offset rightBottom = Offset(rightX, bottomY);

    // 左端と右端の角度を計算
    final double startAngleFull = atan2(leftBottom.dy - center.dy, leftBottom.dx - center.dx);
    final double endAngleFull = atan2(rightBottom.dy - center.dy, rightBottom.dx - center.dx);

    // 全体の角度差を計算
    double angleDifferenceFull;
    if (endAngleFull <= startAngleFull) {
      angleDifferenceFull = endAngleFull + 2 * pi - startAngleFull;
    } else {
      angleDifferenceFull = endAngleFull - startAngleFull;
    }

    // 指定した位置の角度を計算
    final double angleAtPosition = startAngleFull + angleDifferenceFull * position;

    // 角度幅を計算
    final double angleWidth = angleDifferenceFull * angleWidthFraction;

    // 描画する開始角度と終了角度を計算
    double startAngleArc = angleAtPosition - angleWidth;
    double endAngleArc = angleAtPosition + angleWidth;

    // 角度が0〜2πの範囲に収まるように調整
    startAngleArc = (startAngleArc + 2 * pi) % (2 * pi);
    endAngleArc = (endAngleArc + 2 * pi) % (2 * pi);

    // 弧を描画するための矩形と太さを定義
    final Rect arcRect = Rect.fromCircle(center: center, radius: (innerRadius + outerRadius) / 2);
    final double arcThickness = (outerRadius - innerRadius);

    // 弧を描画
    final Paint arcPaint = Paint()
      ..color = const Color(0xFF51DB40)
      ..strokeWidth = arcThickness
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      arcRect,
      startAngleArc,
      endAngleArc - startAngleArc,
      false,
      arcPaint,
    );
  }

  void _drawCenteredText(Canvas canvas, Offset center) {
    // 上のテキスト
    const TextSpan topTextSpan = TextSpan(
      text: '300w',
      style: TextStyle(
        color: Colors.white,
        fontSize: 60,
        fontWeight: FontWeight.bold,
      ),
    );

    // 下のテキスト
    const TextSpan bottomTextSpan = TextSpan(
      text: '90rpm',
      style: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );

    // 上のテキストを描画
    final TextPainter topTextPainter = TextPainter(
      text: topTextSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    topTextPainter.layout();

    // 下のテキストを描画
    final TextPainter bottomTextPainter = TextPainter(
      text: bottomTextSpan,
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );
    bottomTextPainter.layout();

    // テキストの合計高さを計算
    final double totalTextHeight = topTextPainter.height + bottomTextPainter.height;

    // 上のテキストの位置を計算
    final Offset topTextOffset = Offset(
      center.dx - topTextPainter.width / 2,
      center.dy - totalTextHeight / 2,
    );

    // 下のテキストの位置を計算
    final Offset bottomTextOffset = Offset(
      center.dx - bottomTextPainter.width / 4,
      topTextOffset.dy + topTextPainter.height,
    );

    // テキストをキャンバスに描画
    topTextPainter.paint(canvas, topTextOffset);
    bottomTextPainter.paint(canvas, bottomTextOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
