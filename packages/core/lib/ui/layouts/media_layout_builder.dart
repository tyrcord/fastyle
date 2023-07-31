// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

typedef FastMediaLayoutWidgetBuilder = Widget Function(
  BuildContext context,
  FastMediaType mediaType,
);

class FastMediaLayoutBuilder extends StatelessWidget {
  final FastMediaLayoutWidgetBuilder builder;

  const FastMediaLayoutBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FastMediaLayoutBloc>(context);

    return BlocBuilderWidget(
      forceBuildWhenInializating: false,
      forceBuildWhenBusy: false,
      buildWhen: buildWhen,
      builder: buildChild,
      bloc: bloc,
    );
  }

  bool buildWhen(
    FastMediaLayoutBlocState previous,
    FastMediaLayoutBlocState next,
  ) {
    return previous.mediaType != next.mediaType;
  }

  Widget buildChild(BuildContext context, FastMediaLayoutBlocState state) {
    return builder(context, state.mediaType);
  }
}
