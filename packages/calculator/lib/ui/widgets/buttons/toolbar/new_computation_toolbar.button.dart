// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tbloc/tbloc.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

/// A [FastCalculatorAction] that adds two numbers.
class FastCalculatorAddComputationToolbarButton<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends FastCalculatorAction<B, R> {
  final bool Function(FastCalculatorBlocState state)? canEnableInteractions;

  final String? labelText;

  const FastCalculatorAddComputationToolbarButton({
    super.key,
    required super.calculatorBloc,
    this.canEnableInteractions,
    super.disabledColor,
    super.iconColor,
    super.onTap,
    super.icon,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget<FastCalculatorBlocState>(
      buildWhen: _buildWhen,
      bloc: calculatorBloc,
      builder: _buildButton,
    );
  }

  Widget _buildButton(BuildContext context, FastCalculatorBlocState state) {
    return FastToolBarButton(
      isEnabled: shouldEnableInteractions(state),
      onTap: () => handleTap(context),
      disabledColor: disabledColor,
      icon: buildIcon(context),
      shouldTrottleTime: true,
      labelText: labelText,
      iconColor: iconColor,
    );
  }

  bool _buildWhen(
    FastCalculatorBlocState previous,
    FastCalculatorBlocState next,
  ) {
    return previous.isValid != next.isValid;
  }

  void handleTap(BuildContext context) {
    onTap?.call();
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) return icon!;

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightPlus);
    }

    return const FaIcon(FontAwesomeIcons.plus);
  }

  /// Whether the action should be enabled or not.
  @override
  bool shouldEnableInteractions(FastCalculatorBlocState state) {
    if (canEnableInteractions != null) return canEnableInteractions!(state);

    return state.isInitialized;
  }
}