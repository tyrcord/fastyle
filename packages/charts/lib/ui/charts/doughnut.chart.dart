// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_charts/fastyle_charts.dart';

class FastDoughnutChart extends StatelessWidget {
  final List<FastChartData> data;
  final bool animate;
  final double width;
  final double height;

  const FastDoughnutChart({
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
          painter: FastDoughnutChartPainter(
            animationValue: animate ? animationValue : 1.0,
            data: data,
          ),
          child: const SizedBox.shrink(),
        );
      },
    );
  }
}
