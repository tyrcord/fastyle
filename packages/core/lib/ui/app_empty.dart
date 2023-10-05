// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastEmptyApp extends StatelessWidget {
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  final Widget child;

  const FastEmptyApp({
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
        final easyLocalization = EasyLocalization.of(context)!;
        final useDarkTheme = state.brightness == Brightness.dark;
        var theme = lightTheme ?? FastTheme.light.blue;

        if (useDarkTheme && darkTheme != null) {
          theme = darkTheme ?? FastTheme.dark.blue;
        }

        return Localizations(
          delegates: easyLocalization.delegates,
          locale: easyLocalization.locale,
          child: MediaQuery.fromView(
            view: View.of(context),
            child: AnimatedTheme(
              data: theme,
              child: Builder(
                builder: (context) {
                  return FastPrimaryBackgroundContainer(
                    child: FastPageLayout(child: child),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
