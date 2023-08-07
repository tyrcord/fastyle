// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppOnboardingJob extends FastJob {
  static FastAppOnboardingJob? _singleton;

  factory FastAppOnboardingJob() {
    return (_singleton ??= const FastAppOnboardingJob._());
  }

  const FastAppOnboardingJob._() : super(debugLabel: 'fast_app_onboarding_job');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final bloc = BlocProvider.of<FastAppOnboardingBloc>(context);
    bloc.addEvent(const FastAppOnboardingBlocEvent.init());

    final onboardingState = await RaceStream([
      bloc.onError,
      bloc.onData
          .where((FastAppOnboardingBlocState state) => state.isInitialized),
    ]).first;

    if (onboardingState is! FastAppOnboardingBlocState) {
      throw onboardingState;
    }
  }
}
