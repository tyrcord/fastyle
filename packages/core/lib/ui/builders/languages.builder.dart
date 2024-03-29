// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppSettingsLanguagesBuilder extends StatelessWidget {
  final BlocBuilder<FastAppInfoBlocState> builder;

  /// Creates a new `FastAppSettingsLanguagesBuilder` instance.
  ///
  /// The `builder` parameter is a required function that takes the
  /// [BuildContext] and [FastAppInfoBlocState] as input and returns
  /// a widget.
  const FastAppSettingsLanguagesBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      buildWhen: (previous, next) {
        return previous.supportedLocales != next.supportedLocales;
      },
      bloc: FastAppInfoBloc.instance,
      builder: builder,
    );
  }
}
