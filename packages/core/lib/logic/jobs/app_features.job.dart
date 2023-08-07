// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppFeaturesJob extends FastJob {
  static FastAppFeaturesJob? _singleton;

  factory FastAppFeaturesJob() {
    return (_singleton ??= const FastAppFeaturesJob._());
  }

  const FastAppFeaturesJob._() : super(debugLabel: 'fast_app_features_job');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final bloc = BlocProvider.of<FastAppFeaturesBloc>(context);
    bloc.addEvent(const FastAppFeaturesBlocEvent.init());

    final blocState = await RaceStream([
      bloc.onError,
      bloc.onData
          .where((FastAppFeaturesBlocState state) => state.isInitialized),
    ]).first;

    if (blocState is! FastAppFeaturesBlocState) {
      throw blocState;
    }
  }
}
