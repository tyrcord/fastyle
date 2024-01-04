// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tbloc/tbloc.dart';
import 'package:tenhance/tenhance.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

/// A widget that provides a toggle action between chart and list views in a
/// calculator application.
class FastCalculatorChartToggle<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends FastCalculatorAction<B, R> {
  final ValueNotifier<bool> _chartViewNotifier;
  final FastMediaType? mediaTypeThreshold;
  final Widget? _chartIcon;
  final Widget? _listIcon;

  const FastCalculatorChartToggle({
    super.key,
    required super.calculatorBloc,
    required ValueNotifier<bool> chartViewNotifier,
    this.mediaTypeThreshold,
    super.disabledColor,
    Widget? chartIcon,
    Widget? listIcon,
  })  : _chartViewNotifier = chartViewNotifier,
        _chartIcon = chartIcon,
        _listIcon = listIcon;

  @override
  Widget build(BuildContext context) {
    if (mediaTypeThreshold == null) {
      return _buildCalculatorActionButton(context);
    }

    return FastMediaLayoutBuilder(
      builder: (context, mediaType) {
        final isDesktop = mediaType > FastMediaType.tablet;

        if (!isDesktop) return _buildCalculatorActionButton(context);

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCalculatorActionButton(BuildContext context) {
    return BlocBuilderWidget<FastCalculatorBlocState>(
      buildWhen: (previous, next) => previous.isDirty != next.isDirty,
      builder: (context, state) => _buildActionButton(context, state),
      bloc: calculatorBloc,
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    FastCalculatorBlocState state,
  ) {
    final primaryColor = ThemeHelper.colors.getPrimaryColor(context);

    return ValueListenableBuilder<bool>(
      valueListenable: _chartViewNotifier,
      builder: (context, showChart, child) {
        final icon =
            showChart ? _buildListIcon(context) : _buildChartIcon(context);

        return FastIconButton(
          onTap: () => _chartViewNotifier.value = !showChart,
          isEnabled: state.isInitialized && state.isValid,
          iconAlignment: Alignment.centerRight,
          iconColor: primaryColor,
          icon: icon,
        );
      },
    );
  }

  Widget _buildChartIcon(BuildContext context) {
    return _chartIcon ?? _defaultChartIcon(context);
  }

  Widget _buildListIcon(BuildContext context) {
    return _listIcon ?? _defaultListIcon(context);
  }

  Widget _defaultChartIcon(BuildContext context) {
    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(
        FastFontAwesomeIcons.lightChartPieSimple,
        size: kFastIconSizeSmall,
      );
    }

    return const FaIcon(FontAwesomeIcons.chartPie, size: kFastIconSizeSmall);
  }

  Widget _defaultListIcon(BuildContext context) {
    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(
        FastFontAwesomeIcons.lightListOl,
        size: kFastIconSizeSmall,
      );
    }

    return const FaIcon(FontAwesomeIcons.listOl, size: kFastIconSizeSmall);
  }

  @override
  bool shouldEnableInteractions(FastCalculatorBlocState state) {
    return state.isInitialized && state.isValid;
  }
}
