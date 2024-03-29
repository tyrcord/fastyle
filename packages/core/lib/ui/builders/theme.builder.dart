// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// A widget that listens to changes in the `FastSettingsBloc` and rebuilds its
/// child widget when the theme mode changes.
class FastAppSettingsThemeBuilder extends StatelessWidget {
  /// The builder function that will be called when the theme mode changes.
  final BlocBuilder<FastAppSettingsBlocState> builder;

  /// Creates a new `FastSettingsThemeBuilder` instance.
  ///
  /// The `builder` parameter is a required function that takes the
  /// [BuildContext] and [FastAppSettingsBlocState] as input and returns a
  /// widget.
  const FastAppSettingsThemeBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      buildWhen: (previous, next) => previous.theme != next.theme,
      bloc: FastAppSettingsBloc.instance,
      builder: builder,
    );
  }
}
