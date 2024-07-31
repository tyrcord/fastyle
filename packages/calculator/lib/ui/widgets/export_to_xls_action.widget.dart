// Flutter imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

/// A [FastCalculatorAction] that clears the calculator state.
class FastCalculatorExportToXlsAction<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends FastCalculatorAction<B, R> {
  final bool Function(FastCalculatorBlocState state)? canEnableInteractions;

  final Color? color;

  const FastCalculatorExportToXlsAction({
    super.key,
    required super.calculatorBloc,
    this.canEnableInteractions,
    super.disabledColor,
    super.icon,
    this.color,
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
    return FastIconButton2(
      isEnabled: shouldEnableInteractions(state),
      emphasis: FastButtonEmphasis.high,
      onTap: () => handleTap(context),
      disabledColor: disabledColor,
      icon: buildIcon(context),
      shouldTrottleTime: true,
      iconColor: color,
    );
  }

  bool _buildWhen(
    FastCalculatorBlocState previous,
    FastCalculatorBlocState next,
  ) {
    return previous.isValid != next.isValid;
  }

  void handleTap(BuildContext context) {
    calculatorBloc.addEvent(FastCalculatorBlocEvent.exportToExcel(context));
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) return icon!;

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightFileXls);
    }

    return const FaIcon(FontAwesomeIcons.fileExcel);
  }

  /// Whether the action should be enabled or not.
  @override
  bool shouldEnableInteractions(FastCalculatorBlocState state) {
    if (canEnableInteractions != null) return canEnableInteractions!(state);

    return state.isInitialized && state.isValid && !state.isBusy;
  }
}
