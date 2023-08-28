import 'package:flutter/material.dart';

class FastChartData {
  final Tween<double> tween;
  final double value;
  final Color color;
  final String label;

  FastChartData({
    required this.value,
    required this.label,
    Color? color,
  })  : tween = Tween<double>(begin: 0, end: value),
        color = color ?? Colors.blue;
}
