// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastPadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const FastPadding({
    Key? key,
    required this.child,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}

class FastPadding24 extends FastPadding {
  const FastPadding24({
    Key? key,
    required Widget child,
    EdgeInsets padding = kFastEdgeInsets24,
  }) : super(
          key: key,
          child: child,
          padding: padding,
        );
}

class FastPadding16 extends FastPadding {
  const FastPadding16({
    Key? key,
    required Widget child,
    EdgeInsets padding = kFastEdgeInsets16,
  }) : super(
          key: key,
          child: child,
          padding: padding,
        );
}

class FastPadding12 extends FastPadding {
  const FastPadding12({
    Key? key,
    required Widget child,
    EdgeInsets padding = kFastEdgeInsets12,
  }) : super(
          key: key,
          child: child,
          padding: padding,
        );
}

class FastPadding8 extends FastPadding {
  const FastPadding8({
    Key? key,
    required Widget child,
    EdgeInsets padding = kFastEdgeInsets8,
  }) : super(
          key: key,
          child: child,
          padding: padding,
        );
}
