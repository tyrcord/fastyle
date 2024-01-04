// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:t_helpers/helpers.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FastAnimatedNumberText extends StatefulWidget {
  final double endValue;
  final Duration duration;
  final FontWeight? fontWeight;
  final TextAlign textAlign;
  final Color? textColor;
  final String? locale;
  final int minimumFractionDigits;
  final int maximumFractionDigits;
  final double? fontSize;
  final String? currencyCode;

  const FastAnimatedNumberText({
    super.key,
    required this.endValue,
    this.textAlign = TextAlign.left,
    this.duration = const Duration(milliseconds: 350),
    this.fontWeight,
    this.fontSize,
    this.textColor,
    this.locale,
    this.minimumFractionDigits = 0,
    this.maximumFractionDigits = 0,
    this.currencyCode,
  });

  @override
  AnimatedNumberWidgetState createState() => AnimatedNumberWidgetState();
}

class AnimatedNumberWidgetState extends State<FastAnimatedNumberText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final Key _key = UniqueKey();

  late Animation<double> _animation;
  double _currentValue = 0;
  double _visibleFraction = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(FastAnimatedNumberText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.endValue != widget.endValue) {
      setState(() {
        _currentValue = 0;
        _controller.reset();
        _startAnimationIfNeeded();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handleVisibilityChanged(VisibilityInfo info) {
    _visibleFraction = info.visibleFraction;
    _startAnimationIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: VisibilityDetector(
        key: _key,
        onVisibilityChanged: handleVisibilityChanged,
        child: FastBody(
          text: _formatNumber(),
          textColor: widget.textColor,
          textAlign: widget.textAlign,
          fontWeight: widget.fontWeight,
          fontSize: widget.fontSize,
        ),
      ),
    );
  }

  String _formatNumber() {
    if (widget.currencyCode != null) {
      return formatCurrency(
        value: _currentValue,
        locale: widget.locale,
        symbol: widget.currencyCode!,
        minimumFractionDigits: widget.minimumFractionDigits,
        maximumFractionDigits: widget.maximumFractionDigits,
      );
    }

    return formatDecimal(
      value: _currentValue,
      locale: widget.locale,
      minimumFractionDigits: widget.minimumFractionDigits,
      maximumFractionDigits: widget.maximumFractionDigits,
    );
  }

  void _startAnimationIfNeeded() {
    if (_visibleFraction == 1 &&
        _currentValue == 0 &&
        !_controller.isAnimating &&
        !_controller.isCompleted) {
      _animation = Tween<double>(begin: _currentValue, end: widget.endValue)
          .animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuint,
      ))
        ..addListener(() {
          if (!mounted) return;

          setState(() => _currentValue = _animation.value);
        });

      _controller.forward();
    }
  }
}
