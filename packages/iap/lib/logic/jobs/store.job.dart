// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

class FastIapStoreJob extends FastJob {
  static FastIapStoreJob? _singleton;

  factory FastIapStoreJob() {
    return (_singleton ??= const FastIapStoreJob._());
  }

  const FastIapStoreJob._()
      : super(
          debugLabel: 'FastIapStoreJob',
          blockStartupOnFailure: false,
        );

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    if (isWeb) return;

    final appInfoBloc = FastAppInfoBloc.instance;
    final appInfoState = appInfoBloc.currentState;

    if (appInfoState.productIdentifiers == null ||
        appInfoState.productIdentifiers!.isEmpty) {
      return;
    }

    // The store must not prevent the app from starting: when it is
    // unavailable or too slow to answer, the app starts without its products
    // and the store keeps initializing in the background.
    try {
      await _initializeStore(
        appInfoState.toDocument(),
        errorReporter: errorReporter,
      ).timeout(kFastIapStoreJobTimeout);
    } catch (error, stackTrace) {
      errorReporter?.recordError(
        error,
        stackTrace,
        reason: 'The store is unavailable, the app starts without it',
      );
    }
  }

  Future<void> _initializeStore(
    FastAppInfoDocument appInfo, {
    IFastErrorReporter? errorReporter,
  }) async {
    final storeBloc = FastStoreBloc.instance;
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
        storeBloc.onData.where((FastStoreBlocState state) {
          return state.hasLoadedProducts ||
              (!state.isLoadingProducts && state.error != null);
        }),
      ]).first;

      if (onboardingState is! FastStoreBlocState) {
        throw onboardingState;
      }

      if (!onboardingState.hasLoadedProducts) {
        throw onboardingState.error as Object;
      }
    }
  }
}
