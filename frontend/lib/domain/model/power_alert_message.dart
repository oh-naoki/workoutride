import 'package:flutter/material.dart';

enum PowerAlertMessage {
  powerTooLow("もっとパワーをあげてください", Colors.blue),
  powerTooHigh("パワーをだしすぎです", Colors.red);

  const PowerAlertMessage(this.message, this.color);

  final String message;
  final Color color;
}
