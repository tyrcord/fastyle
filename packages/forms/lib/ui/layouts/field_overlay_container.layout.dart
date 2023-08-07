// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:tbloc/tbloc.dart';

/// A custom [StatelessWidget] that creates a scaffold with a customizable
/// header.
///
/// The header includes a title and optional leading and valid icons.
class FastFieldOverlayContainer<T> extends StatelessWidget {
  /// Callback function to be executed when the overlay container is closed.
  final T Function()? willClose;

  /// Callback function to be executed when the valid icon is tapped.
  final T Function()? willValid;

  /// The title text to display in the header.
  final String? titleText;

  /// The valid icon to display in the header.
  final Widget? validIcon;

  /// The close icon to display in the header.
  final Widget? closeIcon;

  /// The back icon to display in the header.
  final Widget? backIcon;

  /// The main content of the overlay container.
  final Widget child;

  /// The maximum width of the headline in the header.
  final double maxHeadlineWidth;

  // Constants for small screen height
  static const double kSmallScreenHeight = 640;

  /// Creates a new instance of [FastFieldOverlayContainer].
  ///
  /// [titleText] is the title of the header.
  /// [child] is the main content of the overlay container.
  /// [closeIcon], [backIcon], [validIcon], [willClose], and [willValid] are
  /// optional parameters.
  const FastFieldOverlayContainer({
    super.key,
    required this.titleText,
    required this.child,
    this.closeIcon,
    this.backIcon,
    this.validIcon,
    this.willClose,
    this.willValid,
    double? maxHeadlineWidth,
  }) : maxHeadlineWidth = maxHeadlineWidth ?? 640;

  /// Builds the overlay container with a header and the main content.
  @override
  Widget build(BuildContext context) {
    final themeBloc = BlocProvider.of<FastThemeBloc>(context);
    final brightness = themeBloc.currentState.brightness;
    final overlayStyle = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (titleText != null) _buildHeader(context),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  /// Builds the header with a title and optional icons.
  Widget _buildHeader(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.height < kSmallScreenHeight;

    return ColoredBox(
      color: ThemeHelper.colors.getSecondaryBackgroundColor(context),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderActions(context, isSmallScreen: isSmallScreen),
            if (!isSmallScreen) _buildHeadline(context),
          ],
        ),
      ),
    );
  }

  /// Builds the title widget displayed in the header.
  Widget _buildHeadline(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxHeadlineWidth),
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
        ),
        child: FastHeadline(text: titleText!),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Center(
      child: FastSubtitle(text: titleText!),
    );
  }

  /// Builds the header actions with leading and valid icons.
  Widget _buildHeaderActions(
    BuildContext context, {
    bool isSmallScreen = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLeadingIcon(context),
        if (isSmallScreen) _buildTitle(context),
        if (validIcon != null) _buildTralingIcon(context),
      ],
    );
  }

  /// Builds the trailing icon based on the current route's properties.
  Widget _buildTralingIcon(BuildContext context) {
    return FastIconButton(
      onTap: () => _valid(context),
      iconSize: kFastIconSizeLarge,
      icon: validIcon!,
    );
  }

  /// Builds the leading icon based on the current route's properties.
  Widget _buildLeadingIcon(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    // Determines if the current route can be popped.
    final canPop = parentRoute?.canPop ?? false;

    // If the route can be popped, build the leading icon.
    if (canPop) {
      // Determine whether to use the close button or the back button.
      final useCloseButton =
          parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

      if (useCloseButton) {
        return FastCloseButton(onTap: () => _close(context));
      }

      return FastBackButton(onTap: () => _close(context));
    }

    // If the route can't be popped, return an empty Container.
    return Container();
  }

  /// Closes the overlay container and pops the current route.
  ///
  /// If the [willClose] callback is provided, it's executed and its return
  /// value is passed back.
  void _close(BuildContext context) {
    T? value;

    if (willClose != null) {
      value = willClose!();
    }

    Navigator.pop(context, value);
  }

  /// Validates the overlay container and pops the current route.
  ///
  /// If the [willValid] callback is provided, it's executed and its return
  /// value is passed back.
  void _valid(BuildContext context) {
    T? value;

    if (willValid != null) {
      value = willValid!();
    }

    Navigator.pop(context, value);
  }
}
