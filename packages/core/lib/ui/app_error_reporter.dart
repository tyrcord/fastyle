// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastAppErrorReporter extends InheritedWidget {
  final IFastErrorReporter? reporter;

  const FastAppErrorReporter({
    super.key,
    required super.child,
    this.reporter,
  });

  static FastAppErrorReporter? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FastAppErrorReporter>();
  }

  @override
  bool updateShouldNotify(FastAppErrorReporter oldWidget) {
    return reporter != oldWidget.reporter;
  }
}
