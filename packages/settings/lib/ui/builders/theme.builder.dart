import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:tbloc_dart/tbloc_dart.dart';
import 'package:flutter/material.dart';

/// The [FastSettingsThemeBuilder] class is a [StatefulWidget] that listens
/// to the [FastSettingsBloc] and builds its child widget when the theme
/// mode changes.
class FastSettingsThemeBuilder extends StatefulWidget {
  /// The builder function that will be called when the theme mode changes.
  final BlocBuilder<FastSettingsBlocState> builder;

  const FastSettingsThemeBuilder({
    super.key,
    required this.builder,
  });

  @override
  State<FastSettingsThemeBuilder> createState() =>
      _FastSettingsThemeBuilderState();
}

class _FastSettingsThemeBuilderState extends State<FastSettingsThemeBuilder>
    with FastSettingsThemeMixin {
  late final FastSettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();
    _settingsBloc = BlocProvider.of<FastSettingsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      buildWhen: (previous, next) => previous.theme != next.theme,
      builder: widget.builder,
      bloc: _settingsBloc,
    );
  }
}
