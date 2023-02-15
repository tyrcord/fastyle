import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';

class FastCalculatorPageLayout<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends StatelessWidget {
  final List<Widget>? calculatorActions;
  final List<Widget>? resultsActions;
  final WidgetBuilder? dividerBuilder;
  final WidgetBuilder? headerBuilder;
  final WidgetBuilder? footerBuilder;
  final WidgetBuilder resultsBuilder;
  final WidgetBuilder fieldsBuilder;
  final String? resultsTitleText;
  final String? fieldsTitleText;
  final String? pageTitleText;
  final bool showRefreshIcon;
  final bool requestFullApp;
  final Widget? refreshIcon;
  final bool showClearIcon;
  final Widget? backButton;
  final Widget? shareIcon;
  final Widget? clearIcon;
  final B calculatorBloc;
  final Widget? leading;

  const FastCalculatorPageLayout({
    Key? key,
    required this.calculatorBloc,
    required this.resultsBuilder,
    required this.fieldsBuilder,
    this.requestFullApp = false,
    this.showRefreshIcon = true,
    this.showClearIcon = true,
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
    this.shareIcon,
    this.clearIcon,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FastMediaLayoutBuilder(
      builder: (BuildContext context, FastMediaType mediaType) {
        return FastSectionPage(
          isTitlePositionBelowAppBar: !requestFullApp,
          titleText: pageTitleText,
          backButton: backButton,
          actions: _buildActions(),
          leading: leading,
          isViewScrollable: true,
          child: Builder(
            builder: (BuildContext context) {
              if (mediaType.index >= FastMediaType.tablet.index) {
                return _buildGridView(context);
              }

              return _buildColumnView(context);
            },
          ),
          footerBuilder: (context) => _buildFooter(mediaType),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context) {
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
            Flexible(child: _buildResults(context)),
          ],
        ),
      ],
    );
  }

  Widget _buildColumnView(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildFormFields(context),
        _buildDivider(context),
        _buildResults(context),
      ],
    );
  }

  Widget _buildHeader() {
    if (headerBuilder != null) {
      return Builder(builder: headerBuilder!);
    }

    return Container();
  }

  Widget _buildFooter(FastMediaType mediaType) {
    if (footerBuilder != null) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          widthFactor: mediaType.index >= FastMediaType.tablet.index ? 0.5 : 1,
          child: Builder(builder: footerBuilder!),
        ),
      );
    }

    return Container();
  }

  List<Widget> _buildActions() {
    return [
      FastCalculatorShareAction<B, R>(
        calculatorBloc: calculatorBloc,
        icon: shareIcon,
      ),
    ];
  }

  Widget _buildFormFields(BuildContext context) {
    final primaryColor = ThemeHelper.colors.getPrimaryColor(context);

    return FastCard(
      titleText: fieldsTitleText ?? kFastCalculatorTitle,
      titleTextColor: primaryColor,
      headerActions: <Widget>[
        ...?calculatorActions,
        if (showClearIcon)
          FastCalculatorClearAction<B, R>(
            calculatorBloc: calculatorBloc,
            icon: clearIcon,
          )
      ],
      child: Builder(builder: fieldsBuilder),
    );
  }

  Widget _buildDivider(BuildContext context) {
    if (dividerBuilder != null) {
      final spacing = ThemeHelper.spacing.getSpacing(context);

      return Padding(
        padding: EdgeInsets.symmetric(vertical: spacing / 2),
        child: Builder(builder: dividerBuilder!),
      );
    }

    return ThemeHelper.spacing.getVerticalSpacing(context);
  }

  Widget _buildResults(BuildContext context) {
    final primaryColor = ThemeHelper.colors.getPrimaryColor(context);

    return FastCard(
      titleText: resultsTitleText ?? kFastCalculatorResultsTitle,
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
}
