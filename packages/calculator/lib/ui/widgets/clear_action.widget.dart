// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

/// A [FastCalculatorAction] that clears the calculator state.
class FastCalculatorClearAction<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends FastCalculatorAction<B, R> {
  const FastCalculatorClearAction({
    super.key,
    required super.calculatorBloc,
    super.disabledColor,
    super.icon,
    super.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = ThemeHelper.colors.getPrimaryColor(context);

    return BlocBuilderWidget<FastCalculatorBlocState>(
      bloc: calculatorBloc,
      buildWhen: (previous, next) => previous.isDirty != next.isDirty,
      builder: (_, FastCalculatorBlocState state) {
        return FastIconButton(
          isEnabled: shouldEnableInteractions(state),
          iconAlignment: Alignment.centerRight,
          disabledColor: disabledColor,
          icon: buildIcon(context),
          iconColor: primaryColor,
          shouldTrottleTime: true,
          onTap: () {
            calculatorBloc.addEvent(FastCalculatorBlocEvent.clear<R>());
            onTap?.call();
          },
        );
      },
    );
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) {
      return icon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(
        FastFontAwesomeIcons.lightEraser,
        size: kFastIconSizeSmall,
      );
    }

    return const FaIcon(
      FontAwesomeIcons.eraser,
      size: kFastIconSizeSmall,
    );
  }

  /// Whether the action should be enabled or not.
  @override
  bool shouldEnableInteractions(FastCalculatorBlocState state) {
    return state.isInitialized && state.isDirty;
  }
}
