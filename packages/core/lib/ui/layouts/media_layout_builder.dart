// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

typedef FastMediaLayoutWidgetBuilder = Widget Function(
  BuildContext context,
  FastMediaType mediaType,
);

class FastMediaLayoutBuilder extends StatelessWidget {
  final FastMediaLayoutWidgetBuilder builder;

  const FastMediaLayoutBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      bloc: FastMediaLayoutBloc.instance,
      forceBuildWhenInializating: false,
      forceBuildWhenBusy: false,
      buildWhen: buildWhen,
      builder: buildChild,
    );
  }

  bool buildWhen(previous, next) {
    return previous.mediaType != next.mediaType;
  }

  Widget buildChild(BuildContext context, FastMediaLayoutBlocState state) {
    return builder(context, state.mediaType);
  }
}
