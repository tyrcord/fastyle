// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:visibility_detector/visibility_detector.dart';

typedef ChartBuilder = Widget Function(
  BuildContext context,
  double animationValue,
);

class FastChart extends StatefulWidget {
  final ChartBuilder chartBuilder;
  final bool animate;
  final double width;
  final double height;
  final double visibleFractionThreshold;

  const FastChart({
    super.key,
    required this.chartBuilder,
    this.animate = false,
    double? width = 200,
    double? height = 200,
    double? visibleFractionThreshold = 0.5,
  })  : visibleFractionThreshold = visibleFractionThreshold ?? 0.5,
        width = width ?? 200,
        height = height ?? 200;

  @override
  FastChartState createState() => FastChartState();
}

class FastChartState extends State<FastChart>
    with SingleTickerProviderStateMixin {
  final _key = UniqueKey();
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentAnimationValue = 0.0;
  bool _hasBeenVisible = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.addListener(handleAnimationChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handleAnimationChanged() {
    if (!mounted) return;

    setState(() => _currentAnimationValue = _animation.value);
  }

  Future<void> handleVisibilityChanged(VisibilityInfo info) async {
    if (info.visibleFraction >= widget.visibleFractionThreshold &&
        !_hasBeenVisible) {
      _hasBeenVisible = true;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: VisibilityDetector(
        key: _key,
        onVisibilityChanged: handleVisibilityChanged,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Builder(builder: (context) {
            return widget.chartBuilder(context, _currentAnimationValue);
          }),
        ),
      ),
    );
  }
}
