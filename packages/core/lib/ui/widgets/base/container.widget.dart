// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// A stateless widget that displays a container with the primary
/// background color of the current theme.
///
/// If a [child] widget is provided, it will be displayed inside this container.
class FastPrimaryBackgroundContainer extends StatelessWidget {
  /// The child widget to be displayed inside the container.
  final Widget? child;

  /// Constructs a [FastPrimaryBackgroundContainer] with an optional [child].
  const FastPrimaryBackgroundContainer({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    final colors = ThemeHelper.colors;
    final backgroundColor = colors.getPrimaryBackgroundColor();

    return ColoredBox(
      color: backgroundColor,
      child: child,
    );
  }
}
