// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tbloc/tbloc.dart';
import 'package:fastyle_iap/fastyle_iap.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppOnboardingJob extends FastJob {
  static FastAppOnboardingJob? _singleton;

  factory FastAppOnboardingJob() {
    return (_singleton ??= FastAppOnboardingJob._());
  }

  FastAppOnboardingJob._() : super(debugLabel: 'fast_iap_store_job');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final appInfoBloc = BlocProvider.of<FastAppInfoBloc>(context);
    final bloc = BlocProvider.of<FastStoreBloc>(context);
    final appInfoState = appInfoBloc.currentState;
    final appInfo = appInfoState.toDocument();
    bloc.addEvent(
      FastStoreBlocEvent.init(appInfo, errorReporter: errorReporter),
    );

    final onboardingState = await RaceStream([
      bloc.onError,
      bloc.onData.where((FastStoreBlocState state) => state.isInitialized),
    ]).first;

    if (onboardingState is! FastAppOnboardingBlocState) {
      throw onboardingState;
    }
  }
}
