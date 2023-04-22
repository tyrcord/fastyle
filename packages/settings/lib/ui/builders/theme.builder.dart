import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:flutter/material.dart';
import 'package:tbloc/tbloc.dart';

/// A widget that listens to changes in the `FastSettingsBloc` and rebuilds its
/// child widget when the theme mode changes.
class FastSettingsThemeBuilder extends StatelessWidget {
  /// The builder function that will be called when the theme mode changes.
  final BlocBuilder<FastSettingsBlocState> builder;

  /// Creates a new `FastSettingsThemeBuilder` instance.
  ///
  /// The `builder` parameter is a required function that takes the
  /// [BuildContext] and [FastSettingsBlocState] as input and returns a widget.
  const FastSettingsThemeBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      buildWhen: (previous, next) => previous.theme != next.theme,
      bloc: BlocProvider.of<FastSettingsBloc>(context),
      builder: builder,
    );
  }
}
