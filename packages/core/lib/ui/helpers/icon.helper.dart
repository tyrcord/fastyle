// Flutter imports:
import 'package:flutter/material.dart';

class FastIconHelper extends InheritedWidget {
  final bool useProIcons;

  const FastIconHelper({
    super.key,
    required this.useProIcons,
    required super.child,
  });

  static FastIconHelper? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FastIconHelper>();
  }

  static FastIconHelper of(BuildContext context) {
    final FastIconHelper? result = maybeOf(context);
    assert(result != null, 'No FastIconHelper found in context');

    return result!;
  }

  @override
  bool updateShouldNotify(FastIconHelper oldWidget) {
    return useProIcons != oldWidget.useProIcons;
  }
}
