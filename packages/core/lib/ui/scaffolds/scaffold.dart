// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:tbloc/tbloc.dart';

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
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final themeBloc = BlocProvider.of<FastThemeBloc>(context);
    final brightness = themeBloc.currentState.brightness;
    final palette = ThemeHelper.getPaletteColors(context);
    final isBrightnessLight = brightness == Brightness.light;
    final overlayStyle = !isBrightnessLight
        ? SystemUiOverlayStyle.light
        : ThemeHelper.colors.getOverlayStyleForColor(
            context: context,
            color: appBarBackgroundColor ??
                ThemeHelper.colors.getSecondaryBackgroundColor(context),
          );

    return AppBar(
      surfaceTintColor: appBarBackgroundColor == null
          ? ThemeHelper.colors.getSurfaceTintColor(context)
          : Colors.transparent,
      scrolledUnderElevation: appBarBackgroundColor == null ? null : 0,
      systemOverlayStyle: overlayStyle,
      automaticallyImplyLeading: false,
      leading: leading ?? _buildLeadingIcon(context),
      iconTheme: IconThemeData(
        color: isBrightnessLight
            ? ThemeHelper.texts.getBodyTextStyle(context).color
            : palette.whiteColor,
      ),
      backgroundColor: appBarBackgroundColor ?? Colors.transparent,
      elevation: _kElevation,
      actions: actions,
      title: !isTitlePositionBelowAppBar && titleText != null
          ? FastTitle(text: titleText!, textColor: titleColor, fontSize: 28.0)
          : null,
      centerTitle: false,
    );
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
