// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:tbloc/tbloc.dart';

/// A widget that listens to changes in the `FastAppSettingsBloc` and rebuilds
/// its child widget when the secondary currency changes.
class FastAppSettingsSecondaryCurrencyBuilder extends StatelessWidget {
  /// The builder function that will be called when the secondary currency
  /// changes.
  final BlocBuilder<FastAppSettingsBlocState> builder;

  /// Creates a new `FastAppSettingsSecondaryCurrencyBuilder` instance.
  ///
  /// The `builder` parameter is a required function that takes the
  /// [BuildContext] and [FastAppSettingsBlocState] as input and returns
  /// a widget.
  const FastAppSettingsSecondaryCurrencyBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      buildWhen: (previous, next) =>
          previous.secondaryCurrencyCode != next.secondaryCurrencyCode,
      bloc: FastAppSettingsBloc.instance,
      builder: builder,
    );
  }
}
