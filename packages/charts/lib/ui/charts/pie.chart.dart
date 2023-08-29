import 'package:fastyle_charts/fastyle_charts.dart';
import 'package:flutter/material.dart';

class FastPieChart extends StatelessWidget {
  final List<FastChartData> data;
  final bool animate;
  final double width;
  final double height;

  const FastPieChart({
    super.key,
    required this.data,
    this.animate = false,
    this.width = 200,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return FastChart(
      height: height,
      width: width,
      chartBuilder: (context, animationValue) {
        return CustomPaint(
          painter: FastPieChartPainter(
            data,
            animate ? animationValue : 1.0,
          ),
          child: Container(),
        );
      },
    );
  }
}
