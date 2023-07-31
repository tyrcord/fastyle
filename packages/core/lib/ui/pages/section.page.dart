// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

const _kAppBarHeightSize = Size.fromHeight(kToolbarHeight);

class FastSectionPage extends StatelessWidget {
  ///
  /// The padding for the page.
  ///
  final bool isTitlePositionBelowAppBar;

  ///
  /// Function that creates a widget when the page is loading.
  ///
  final WidgetBuilder? loadingBuilder;

  ///
  /// Function that creates a widget for the page content.
  ///
  final WidgetBuilder? contentBuilder;

  ///
  /// Function that creates a widget for the page footer.
  ///
  final WidgetBuilder? footerBuilder;

  ///
  /// A button displayed floating above body, in the bottom right corner.
  ///
  final Widget? floatingActionButton;

  ///
  /// The AppBar background color.
  ///
  final Color? appBarBackgroundColor;

  ///
  /// Function that creates a widget
  /// when the page has failed to load its content.
  ///
  final WidgetBuilder? errorBuilder;

  ///
  /// A future used to load the page.
  ///
  final Future<bool>? loadingFuture;

  ///
  /// Maximum time for loading the page.
  ///
  final Duration? loadingTimeout;

  ///
  /// The padding for the page.
  ///
  final EdgeInsets? contentPadding;

  ///
  /// Indicates the size of the app bar.
  ///
  final Size appBarHeightSize;

  ///
  /// A list of Widgets to display in a row after the title.
  ///
  final List<Widget>? actions;

  ///
  /// Indicates whether the view is scrollable.
  ///
  final bool isViewScrollable;

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
  /// A widget used as the page footer.
  ///
  final Widget? footer;

  ///
  /// The child contained by the section page.
  ///
  final Widget? child;

  final bool showAppBar;

  const FastSectionPage({
    Key? key,
    this.appBarHeightSize = _kAppBarHeightSize,
    this.isTitlePositionBelowAppBar = true,
    this.isViewScrollable = false,
    this.showAppBar = true,
    this.appBarBackgroundColor,
    this.floatingActionButton,
    this.contentPadding,
    this.loadingTimeout,
    this.contentBuilder,
    this.loadingBuilder,
    this.footerBuilder,
    this.loadingFuture,
    this.errorBuilder,
    this.closeButton,
    this.backButton,
    this.titleColor,
    this.titleText,
    this.actions,
    this.leading,
    this.footer,
    this.child,
  })  : assert(
          contentBuilder == null || child == null,
          'contentBuilder and child properties '
          'should not be initialized together',
        ),
        assert(
          footerBuilder == null || footer == null,
          'footerBuilder and footer properties '
          'should not be initialized together',
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FastScaffold(
      isTitlePositionBelowAppBar: isTitlePositionBelowAppBar,
      appBarBackgroundColor: appBarBackgroundColor,
      floatingActionButton: floatingActionButton,
      appBarHeightSize: appBarHeightSize,
      closeButton: closeButton,
      showAppBar: showAppBar,
      backButton: backButton,
      titleColor: titleColor,
      titleText: titleText,
      actions: actions,
      leading: leading,
      child: FastPageLayout(
        titleText: isTitlePositionBelowAppBar ? titleText : null,
        avoidOperatingSystemInterfaces: !showAppBar,
        isViewScrollable: isViewScrollable,
        loadingBuilder: loadingBuilder,
        loadingTimeout: loadingTimeout,
        contentPadding: contentPadding,
        contentBuilder: contentBuilder,
        footerBuilder: footerBuilder,
        loadingFuture: loadingFuture,
        errorBuilder: errorBuilder,
        titleColor: titleColor,
        footer: footer,
        child: child,
      ),
    );
  }
}
