// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

/// A [FastCalculatorAction] that displays information about the calculator.
class FastCalculatorInfoAction<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends FastCalculatorAction<B, R> {
  /// A callback function that is triggered when the info icon is pressed.
  @override
  final VoidCallback onTap;

  const FastCalculatorInfoAction({
    super.key,
    required super.calculatorBloc,
    required this.onTap,
    super.disabledColor,
    super.icon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget<FastCalculatorBlocState>(
      bloc: calculatorBloc,
      onlyWhenInitializing: true,
      builder: (_, FastCalculatorBlocState state) {
        return FastIconButton(
          icon: buildIcon(context),
          isEnabled: shouldEnableInteractions(state),
          iconAlignment: Alignment.centerRight,
          emphasis: FastButtonEmphasis.high,
          disabledColor: disabledColor,
          shouldTrottleTime: true,
          onTap: onTap,
        );
      },
    );
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) return icon!;

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightCircleInfo);
    }

    return const FaIcon(FontAwesomeIcons.circleInfo);
  }
}
