import 'package:flutter/material.dart';

class FastTooltip extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final Duration waitDuration;
  final bool preferBelow;
  final String message;
  final Widget child;

  const FastTooltip({
    super.key,
    required this.message,
    required this.child,
    this.waitDuration = const Duration(seconds: 1),
    this.margin = const EdgeInsets.only(top: 8),
    this.preferBelow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      waitDuration: waitDuration,
      preferBelow: preferBelow,
      message: message,
      margin: margin,
      child: child,
    );
  }
}
