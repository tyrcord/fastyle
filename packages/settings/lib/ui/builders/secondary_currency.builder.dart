import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';
import 'package:tbloc/tbloc.dart';

/// A widget that listens to changes in the `FastUserSettingsBloc` and rebuilds
/// its child widget when the secondary currency changes.
class FastUserSettingsSecondaryCurrencyBuilder extends StatelessWidget {
  /// The builder function that will be called when the secondary currency
  /// changes.
  final BlocBuilder<FastUserSettingsBlocState> builder;

  /// Creates a new `FastUserSettingsSecondaryCurrencyBuilder` instance.
  ///
  /// The `builder` parameter is a required function that takes the
  /// [BuildContext] and [FastUserSettingsBlocState] as input and returns
  /// a widget.
  const FastUserSettingsSecondaryCurrencyBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      buildWhen: (previous, next) =>
          previous.secondaryCurrencyCode != next.secondaryCurrencyCode,
      bloc: BlocProvider.of<FastUserSettingsBloc>(context),
      builder: builder,
    );
  }
}
