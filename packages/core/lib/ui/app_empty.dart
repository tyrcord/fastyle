// Flutter imports

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

// Package imports

// Project imports

class FastAppSkeleton extends StatelessWidget {
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  final Widget child;

  const FastAppSkeleton({
    super.key,
    required this.child,
    this.lightTheme,
    this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      bloc: FastThemeBloc.instance,
      builder: (BuildContext context, state) {
        final theme = _determineTheme(state);

        return _buildLocalizations(context, theme);
      },
    );
  }

  ThemeData _determineTheme(FastThemeBlocState state) {
    if (state.brightness == Brightness.dark && darkTheme != null) {
      return darkTheme ?? FastTheme.dark.blue;
    }

    return lightTheme ?? FastTheme.light.blue;
  }

  Widget _buildLocalizations(BuildContext context, ThemeData theme) {
    final easyLocalization = EasyLocalization.of(context)!;

    return Localizations(
      delegates: easyLocalization.delegates,
      locale: easyLocalization.locale,
      child: _buildThemedContent(context, theme),
    );
  }

  Widget _buildThemedContent(BuildContext context, ThemeData theme) {
    final themeBloc = FastThemeBloc.instance;
    final brightness = themeBloc.currentState.brightness;
    final overlayStyle = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: MediaQuery.fromView(
        view: View.of(context),
        child: AnimatedTheme(
          data: theme,
          child: FastPrimaryBackgroundContainer(
            child: FastPageLayout(child: child),
          ),
        ),
      ),
    );
  }
}
