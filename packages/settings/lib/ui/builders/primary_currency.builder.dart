import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:flutter/material.dart';
import 'package:tbloc/tbloc.dart';

/// A widget that listens to changes in the `FastUserSettingsBloc` and rebuilds
/// its child widget when the primary currency changes.
class FastUserSettingsPrimaryCurrencyBuilder extends StatelessWidget {
  /// The builder function that will be called when the primary currency
  /// changes.
  final BlocBuilder<FastUserSettingsBlocState> builder;

  /// Creates a new `FastUserSettingsPrimaryCurrencyBuilder` instance.
  ///
  /// The `builder` parameter is a required function that takes the
  /// [BuildContext] and [FastUserSettingsBlocState] as input and returns
  /// a widget.
  const FastUserSettingsPrimaryCurrencyBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      buildWhen: (previous, next) =>
          previous.primaryCurrencyCode != next.primaryCurrencyCode,
      bloc: BlocProvider.of<FastUserSettingsBloc>(context),
      builder: builder,
    );
  }
}
