// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

const _kAppBarHeightSize = Size.fromHeight(kToolbarHeight);
const _kElevation = 0.0;

class FastScaffold extends StatelessWidget {
  ///
  /// The padding for the page.
  ///
  final bool isTitlePositionBelowAppBar;

  ///
  /// A button displayed floating above body, in the bottom right corner.
  ///
  final Widget? floatingActionButton;

  ///
  /// The AppBar background color.
  ///
  final Color? appBarBackgroundColor;

  ///
  /// Indicates the size of the app bar.
  ///
  final Size appBarHeightSize;

  ///
  /// A list of Widgets to display in a row after the title.
  ///
  final List<Widget>? actions;

  ///
  /// The widget used to close the page.
  ///
  final Widget? closeButton;

  ///
  /// The widget used to go back to the previous page.
  ///
  final Widget? backButton;

  ///
  /// The title of the page.
  ///
  final String? titleText;

  ///
  /// Title's color.
  ///
  final Color? titleColor;

  ///
  /// A widget to display before the title.
  ///
  final Widget? leading;

  ///
  /// The child contained by the section page.
  ///
  final Widget? child;

  final bool showAppBar;

  final NavigationBar? bottomNavigationBar;

  final Widget? bottomSheet;

  const FastScaffold({
    super.key,
    this.appBarHeightSize = _kAppBarHeightSize,
    this.isTitlePositionBelowAppBar = true,
    this.showAppBar = true,
    this.appBarBackgroundColor,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.closeButton,
    this.backButton,
    this.titleColor,
    this.titleText,
    this.actions,
    this.leading,
    this.child,
    this.bottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? PreferredSize(
              preferredSize: appBarHeightSize,
              child: _buildAppBar(context),
            )
          : null,
      body: child,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final themeBloc = FastThemeBloc.instance;
    final brightness = themeBloc.currentState.brightness;
    final isBrightnessLight = brightness == Brightness.light;

    return AppBar(
      scrolledUnderElevation: appBarBackgroundColor == null ? null : 0,
      systemOverlayStyle: _getOverlayStyle(context, isBrightnessLight),
      backgroundColor: appBarBackgroundColor ?? Colors.transparent,
      iconTheme: _getIconTheme(context, isBrightnessLight),
      surfaceTintColor: _getSurfaceTintColor(context),
      automaticallyImplyLeading: false,
      leading: _buildLeading(context),
      actions: _buildActions(context),
      elevation: _kElevation,
      title: _buildTitle(),
      centerTitle: false,
    );
  }

  Color _getSurfaceTintColor(BuildContext context) {
    return appBarBackgroundColor == null
        ? ThemeHelper.colors.getSurfaceTintColor(context)
        : Colors.transparent;
  }

  SystemUiOverlayStyle _getOverlayStyle(
    BuildContext context,
    bool isBrightnessLight,
  ) {
    final backgroundColor = appBarBackgroundColor ??
        ThemeHelper.colors.getSecondaryBackgroundColor(context);

    return isBrightnessLight
        ? ThemeHelper.colors.getOverlayStyleForColor(
            color: backgroundColor,
            context: context,
          )
        : SystemUiOverlayStyle.light;
  }

  IconThemeData _getIconTheme(BuildContext context, bool isBrightnessLight) {
    final palette = ThemeHelper.getPaletteColors(context);

    return IconThemeData(
      color: isBrightnessLight
          ? ThemeHelper.texts.getBodyTextStyle(context).color
          : palette.whiteColor,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) {
      return Padding(
        padding: EdgeInsets.only(
          left: ThemeHelper.spacing.getSpacing(context),
        ),
        child: leading,
      );
    }

    return _buildLeadingIcon(context);
  }

  List<Widget> _buildActions(BuildContext context) {
    if (actions != null) {
      final spacing = ThemeHelper.spacing.getHorizontalSpacing(context);

      return [...actions!, spacing];
    }

    return [];
  }

  Widget? _buildTitle() {
    if (!isTitlePositionBelowAppBar && titleText != null) {
      return FastTitle(
        textColor: titleColor,
        text: titleText!,
        fontSize: 28.0,
      );
    }

    return null;
  }

  Widget? _buildLeadingIcon(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final canPop = parentRoute?.canPop ?? false;

    Widget? leading;

    if (canPop) {
      final useCloseButton =
          parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

      leading = useCloseButton
          ? closeButton ?? const FastCloseButton()
          : backButton ?? const FastBackButton();
    }

    return leading;
  }
}
