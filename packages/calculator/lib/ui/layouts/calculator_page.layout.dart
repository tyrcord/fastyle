// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_calculator/generated/locale_keys.g.dart';
import 'package:tbloc/tbloc.dart';
import 'package:tenhance/tenhance.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

/// A widget that provides a layout for a fast calculator app.
class FastCalculatorPageLayout<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends StatelessWidget {
  /// A list of actions that can be performed on the calculator.
  final List<Widget>? calculatorActions;

  /// A list of actions that can be performed on the results section.
  final List<Widget>? resultsActions;

  /// A builder method used to build the divider widget.
  final WidgetBuilder? dividerBuilder;

  /// A builder method used to build the header widget.
  final WidgetBuilder? headerBuilder;

  /// A builder method used to build the footer widget.
  final WidgetBuilder? footerBuilder;

  /// A builder method used to build the UI for displaying the results of
  /// the calculations.
  final WidgetBuilder resultsBuilder;

  /// A builder method used to build the UI for entering input fields and
  /// calculations.
  final WidgetBuilder fieldsBuilder;

  /// A builder method used to build the UI for displaying the breakdown of
  /// the calculations.
  final WidgetBuilder? breakdownBuilder;

  /// A string that represents the title text for the breakdown section.
  /// If null, the default value is used.
  final String? breakdownTitleText;

  /// A list of actions that can be performed on the breakdown section.
  final List<Widget>? breakdownActions;

  /// A string that represents the title text for the results section.
  final String? resultsTitleText;

  /// A string that represents the title text for the input fields section.
  final String? fieldsTitleText;

  /// A string that represents the title text for the calculator page.
  final String? pageTitleText;

  /// A boolean that determines whether the refresh icon should be displayed or
  /// not.
  final bool showRefreshIcon;

  /// A boolean that determines whether the calculator page should request
  /// the full app or not.
  final bool requestFullApp;

  /// A widget that represents the refresh icon.
  final Widget? refreshIcon;

  /// A boolean that determines whether the clear icon should be displayed or
  /// not.
  final bool showClearIcon;

  /// A widget that represents the back button.
  final Widget? backButton;

  /// A widget that represents the exportToPdf icon.
  final Widget? exportToPdfIcon;

  /// A widget that represents the clear icon.
  final Widget? clearIcon;

  /// A boolean that determines whether the info icon should be displayed or
  /// not.
  final bool showInfoIcon;

  /// A widget that represents the info icon.
  final Widget? infoIcon;

  /// A callback function that is triggered when the info icon is pressed.
  final VoidCallback? onInfo;

  /// The calculator bloc used by the calculator page.
  final B calculatorBloc;

  /// A widget that represents the leading widget.
  final Widget? leading;

  final bool Function(FastCalculatorBlocState state)?
      canEnableExportToPdfInteractions;

  final ValueNotifier<bool>? breadownViewNotifier;

  const FastCalculatorPageLayout({
    super.key,
    required this.calculatorBloc,
    required this.resultsBuilder,
    required this.fieldsBuilder,
    this.canEnableExportToPdfInteractions,
    this.requestFullApp = false,
    this.showRefreshIcon = true,
    this.showClearIcon = true,
    this.showInfoIcon = false,
    this.calculatorActions,
    this.resultsTitleText,
    this.fieldsTitleText,
    this.resultsActions,
    this.dividerBuilder,
    this.footerBuilder,
    this.headerBuilder,
    this.pageTitleText,
    this.refreshIcon,
    this.backButton,
    this.exportToPdfIcon,
    this.clearIcon,
    this.infoIcon,
    this.leading,
    this.onInfo,
    this.breakdownBuilder,
    this.breakdownTitleText,
    this.breakdownActions,
    this.breadownViewNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return FastMediaLayoutBuilder(
      builder: (BuildContext context, FastMediaType mediaType) {
        return FastSectionPage(
          isTitlePositionBelowAppBar: !requestFullApp,
          actions: _buildPageActions(),
          titleText: pageTitleText,
          backButton: backButton,
          isViewScrollable: true,
          leading: leading,
          child: BlocBuilderWidget(
            bloc: calculatorBloc,
            forceBuildWhenBusy: false,
            onlyWhenInitializing: true,
            builder: (BuildContext context, state) {
              if (state.isInitialized) {
                if (mediaType >= FastMediaType.tablet) {
                  return _buildGridView(context, mediaType);
                }

                return _buildColumnView(context);
              }

              return const FastPrimaryBackgroundContainer();
            },
          ),
          footerBuilder: (context) => _buildFooter(mediaType),
        );
      },
    );
  }

  /// Builds a two-column grid view for displaying the input fields and
  /// the results in separate columns.
  Widget _buildGridView(BuildContext context, FastMediaType mediaType) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildHeader(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                children: [
                  _buildFormFields(context),
                  _buildDivider(context),
                ],
              ),
            ),
            ThemeHelper.spacing.getHorizontalSpacing(context),
            Flexible(
              flex: mediaType > FastMediaType.tablet ? 2 : 1,
              child: Column(
                children: [
                  _buildResults(context),
                  if (breakdownBuilder != null) ...[
                    _buildDivider(context),
                    _buildBreakdown(context),
                  ]
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds a single-column view for displaying the input fields and
  /// the results.
  Widget _buildColumnView(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildFormFields(context),
        _buildDivider(context),
        _buildResults(context),
        if (breakdownBuilder != null) ...[
          _buildDivider(context),
          _buildBreakdown(context),
        ]
      ],
    );
  }

  /// Builds the header widget based on the [headerBuilder] parameter.
  Widget _buildHeader() {
    if (headerBuilder != null) Builder(builder: headerBuilder!);

    return const SizedBox.shrink();
  }

  /// Builds the footer widget based on the [footerBuilder] parameter.
  Widget _buildFooter(FastMediaType mediaType) {
    if (footerBuilder != null) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          widthFactor: mediaType >= FastMediaType.tablet ? 0.5 : 1,
          child: Builder(builder: footerBuilder!),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  /// Builds a list of action widgets based on the [exportToPdfIcon] parameter.
  List<Widget> _buildPageActions() {
    return [
      if (isExportReportPdfEnabled())
        FastCalculatorExportToPdfAction<B, R>(
          canEnableInteractions: canEnableExportToPdfInteractions,
          calculatorBloc: calculatorBloc,
          icon: exportToPdfIcon,
        ),
    ];
  }

  /// Builds the input fields widget based on the [fieldsTitleText],
  /// [showClearIcon], [clearIcon], [calculatorActions], and
  /// [fieldsBuilder] parameters.
  Widget _buildFormFields(BuildContext context) {
    final primaryColor = ThemeHelper.colors.getPrimaryColor(context);

    return FastCard(
      titleText: fieldsTitleText ??
          CalculatorLocaleKeys.calculator_label_calculator.tr(),
      titleTextColor: primaryColor,
      headerActions: <Widget>[
        ...?calculatorActions,
        if (showInfoIcon && onInfo != null)
          FastCalculatorInfoAction<B, R>(
            calculatorBloc: calculatorBloc,
            icon: infoIcon,
            onTap: onInfo!,
          ),
        if (showClearIcon)
          FastCalculatorClearAction<B, R>(
            calculatorBloc: calculatorBloc,
            icon: clearIcon,
          )
      ],
      child: Builder(builder: fieldsBuilder),
    );
  }

  /// Builds the divider widget based on the [dividerBuilder] parameter.
  Widget _buildDivider(BuildContext context) {
    if (dividerBuilder != null) {
      return Padding(
        padding: ThemeHelper.spacing.getVerticalPadding(context),
        child: Builder(builder: dividerBuilder!),
      );
    }

    return ThemeHelper.spacing.getVerticalSpacing(context);
  }

  /// Builds the results widget based on the [resultsTitleText],
  /// [showRefreshIcon], [refreshIcon], [resultsActions], and
  /// [resultsBuilder] parameters.
  Widget _buildResults(BuildContext context) {
    final primaryColor = ThemeHelper.colors.getPrimaryColor(context);

    return FastCard(
      titleText: resultsTitleText ??
          CalculatorLocaleKeys.calculator_title_results.tr(),
      titleTextColor: primaryColor,
      headerActions: <Widget>[
        ...?resultsActions,
        if (showRefreshIcon)
          FastCalculatorRefreshAction<B, R>(
            calculatorBloc: calculatorBloc,
            icon: refreshIcon,
          ),
      ],
      child: Builder(builder: resultsBuilder),
    );
  }

  Widget _buildBreakdown(BuildContext context) {
    if (breadownViewNotifier == null) return _buildBreakdownCard(context);

    return ValueListenableBuilder<bool>(
      valueListenable: breadownViewNotifier!,
      builder: (context, show, child) {
        if (!show) return const SizedBox.shrink();

        return _buildBreakdownCard(context);
      },
    );
  }

  Widget _buildBreakdownCard(BuildContext context) {
    final primaryColor = ThemeHelper.colors.getPrimaryColor(context);

    return FastCard(
      titleText: breakdownTitleText ??
          CalculatorLocaleKeys.calculator_label_breakdown.tr(),
      titleTextColor: primaryColor,
      headerActions: <Widget>[
        ...?breakdownActions,
      ],
      child: Builder(builder: breakdownBuilder!),
    );
  }
}
