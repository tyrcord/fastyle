import 'package:flutter/material.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:t_helpers/helpers.dart';

class FastAnimatedNumberText extends StatefulWidget {
  final double endValue;
  final Duration duration;
  final FontWeight? fontWeight;
  final TextAlign textAlign;
  final Color? textColor;
  final String? locale;
  final int? minimumFractionDigits;
  final int? maximumFractionDigits;

  const FastAnimatedNumberText({
    super.key,
    required this.endValue,
    this.textAlign = TextAlign.left,
    this.duration = const Duration(seconds: 1),
    this.fontWeight,
    this.textColor,
    this.locale,
    this.minimumFractionDigits,
    this.maximumFractionDigits,
  });

  @override
  AnimatedNumberWidgetState createState() => AnimatedNumberWidgetState();
}

class AnimatedNumberWidgetState extends State<FastAnimatedNumberText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _endValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.endValue)
        .animate(_controller)
      ..addListener(() => setState(() => _endValue = _animation.value));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: FastBody(
        text: formatDecimal(
          value: _endValue,
          locale: widget.locale,
          minimumFractionDigits: widget.minimumFractionDigits,
          maximumFractionDigits: widget.maximumFractionDigits,
        ),
        textColor: widget.textColor,
        textAlign: widget.textAlign,
        fontWeight: widget.fontWeight,
      ),
    );
  }
}
