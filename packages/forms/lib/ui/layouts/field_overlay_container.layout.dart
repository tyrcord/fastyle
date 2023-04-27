import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tbloc/tbloc.dart';

/// A custom [StatelessWidget] that creates a scaffold with a customizable
/// header.
///
/// The header includes a title and optional leading and valid icons.
class FastFieldOverlayContainer<T> extends StatelessWidget {
  // Callback function to be executed when the overlay container is closed.
  final T Function()? willClose;
  // Callback function to be executed when the valid icon is tapped.
  final T Function()? willValid;
  // The title text to display in the header.
  final String? titleText;
  // The valid icon to display in the header.
  final Widget? validIcon;
  // The close icon to display in the header.
  final Widget closeIcon;
  // The back icon to display in the header.
  final Widget backIcon;
  // The main content of the overlay container.
  final Widget child;

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
    this.closeIcon = kFastCloseIcon,
    this.backIcon = kFastBackIcon,
    this.validIcon,
    this.willClose,
    this.willValid,
  });

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
    return Container(
      color: ThemeHelper.colors.getSecondaryBackgroundColor(context),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderActions(context),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              child: FastHeadline(text: titleText!),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the header actions with leading and valid icons.
  Widget _buildHeaderActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLeadingIcon(context),
        if (validIcon != null)
          FastIconButton(
            onTap: () => _valid(context),
            iconSize: kFastIconSizeLarge,
            icon: validIcon!,
          ),
      ],
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

      // Return a FastIconButton with the appropriate icon.
      return FastIconButton(
        icon: useCloseButton ? closeIcon : backIcon,
        onTap: () => _close(context),
        iconSize: kFastIconSizeLarge,
      );
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
