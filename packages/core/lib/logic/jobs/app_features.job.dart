// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppFeaturesJob extends FastJob {
  static FastAppFeaturesJob? _singleton;

  factory FastAppFeaturesJob() {
    return (_singleton ??= const FastAppFeaturesJob._());
  }

  const FastAppFeaturesJob._() : super(debugLabel: 'FastAppFeaturesJob');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final bloc = FastAppFeaturesBloc.instance;
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
