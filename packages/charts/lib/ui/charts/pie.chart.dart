import 'package:fastyle_charts/fastyle_charts.dart';
import 'package:flutter/material.dart';

class FastPieChart extends StatefulWidget {
  final List<FastChartData> data;
  final bool animate;

  const FastPieChart(this.data, {super.key, this.animate = false});

  @override
  FastPieChartState createState() => FastPieChartState();
}

class FastPieChartState extends State<FastPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentAnimationValue = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.addListener(() {
      setState(() {
        _currentAnimationValue = _animation.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: FastPieChartPainter(
        widget.data,
        widget.animate ? _currentAnimationValue : 1.0,
      ),
      child: Container(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
