// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

/// A calculator action widget.
/// Note: This widget is not meant to be used directly.
abstract class FastCalculatorAction<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends StatelessWidget {
  /// The calculator bloc to use.
  final B calculatorBloc;

  /// The icon to use.
  final Widget? icon;

  /// The color to use when the action is disabled.
  final Color? disabledColor;

  final VoidCallback? onTap;

  const FastCalculatorAction({
    super.key,
    required this.calculatorBloc,
    this.disabledColor,
    this.icon,
    this.onTap,
  });

  /// Whether the action should be enabled or not.
  bool shouldEnableInteractions(FastCalculatorBlocState state) {
    return state.isInitialized;
  }
}
