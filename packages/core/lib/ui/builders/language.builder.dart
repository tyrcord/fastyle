// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// A widget that listens to changes in the `FastAppSettingsBloc` and rebuilds
/// its child widget when the language changes.
class FastAppSettingsLanguageBuilder extends StatelessWidget {
  /// The builder function that will be called when the language changes.
  final BlocBuilder<FastAppSettingsBlocState> builder;

  /// Creates a new `FastAppSettingsLanguageBuilder` instance.
  ///
  /// The `builder` parameter is a required function that takes the
  /// [BuildContext] and [FastAppSettingsBlocState] as input and returns
  /// a widget.
  const FastAppSettingsLanguageBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      buildWhen: (previous, next) {
        return previous.languageCode != next.languageCode;
      },
      bloc: BlocProvider.of<FastAppSettingsBloc>(context),
      builder: builder,
    );
  }
}
