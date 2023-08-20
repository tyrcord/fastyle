// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

class FastIapStoreJob extends FastJob {
  static FastIapStoreJob? _singleton;

  factory FastIapStoreJob() {
    return (_singleton ??= const FastIapStoreJob._());
  }

  const FastIapStoreJob._() : super(debugLabel: 'FastIapStoreJob');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final appInfoBloc = FastAppInfoBloc.instance;
    final appInfoState = appInfoBloc.currentState;

    if (appInfoState.productIdentifiers == null ||
        appInfoState.productIdentifiers!.isEmpty) {
      return;
    }

    final storeBloc = FastStoreBloc.instance;
    final appInfo = appInfoState.toDocument();
    storeBloc.addEvent(
      FastStoreBlocEvent.init(appInfo, errorReporter: errorReporter),
    );

    var onboardingState = await RaceStream([
      storeBloc.onError,
      storeBloc.onData.where((FastStoreBlocState state) => state.isInitialized),
    ]).first;

    if (onboardingState is! FastStoreBlocState) {
      throw onboardingState;
    }

    if (storeBloc.currentState.isStoreAvailable) {
      storeBloc.addEvent(const FastStoreBlocEvent.loadProducts());

      onboardingState = await RaceStream([
        storeBloc.onError,
        storeBloc.onData
            .where((FastStoreBlocState state) => state.hasLoadedProducts),
      ]).first;

      if (onboardingState is! FastStoreBlocState) {
        throw onboardingState;
      }
    }
  }
}
