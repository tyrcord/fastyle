// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:tbloc/tbloc.dart';

/// A widget that listens to changes in the `FastAppSettingsBloc` and rebuilds
/// its child widget when the primary currency changes.
class FastAppSettingsPrimaryCurrencyBuilder extends StatelessWidget {
  /// The builder function that will be called when the primary currency
  /// changes.
  final BlocBuilder<FastAppSettingsBlocState> builder;

  /// Creates a new `FastAppSettingsPrimaryCurrencyBuilder` instance.
  ///
  /// The `builder` parameter is a required function that takes the
  /// [BuildContext] and [FastAppSettingsBlocState] as input and returns
  /// a widget.
  const FastAppSettingsPrimaryCurrencyBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      buildWhen: (previous, next) {
        return previous.primaryCurrencyCode != next.primaryCurrencyCode;
      },
      bloc: BlocProvider.of<FastAppSettingsBloc>(context),
      builder: builder,
    );
  }
}
