// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastPadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const FastPadding({
    super.key,
    required this.child,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}

class FastPadding24 extends FastPadding {
  const FastPadding24({
    super.key,
    required super.child,
    super.padding = kFastEdgeInsets24,
  });
}

class FastPadding16 extends FastPadding {
  const FastPadding16({
    super.key,
    required super.child,
    super.padding = kFastEdgeInsets16,
  });
}

class FastPadding12 extends FastPadding {
  const FastPadding12({
    super.key,
    required super.child,
    super.padding = kFastEdgeInsets12,
  });
}

class FastPadding8 extends FastPadding {
  const FastPadding8({
    super.key,
    required super.child,
    super.padding = kFastEdgeInsets8,
  });
}
