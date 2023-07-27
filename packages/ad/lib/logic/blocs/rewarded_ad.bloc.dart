import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';
import 'package:fastyle_ad/fastyle_ad.dart';

class FastRewardedAdBloc
    extends BidirectionalBloc<FastRewardedAdBlocEvent, FastRewardedAdBlocState>
    implements AdEventListener {
  static String debugLabel = 'FastRewardedAdBloc';
  static FastRewardedAdBloc? _singleton;

  late final FastAdmobRewardedAdService _admobService;
  late final Duration blockDuration;

  bool isRequestBlocked = false;
  Timer? blockTimer;

  factory FastRewardedAdBloc({FastRewardedAdBlocState? initialState}) {
    return (_singleton ??= FastRewardedAdBloc._(initialState: initialState));
  }

  FastRewardedAdBloc._({
    FastRewardedAdBlocState? initialState,
  }) : super(initialState: initialState ?? FastRewardedAdBlocState());

  @override
  bool canClose() => false;

  @override
  Stream<FastRewardedAdBlocState> mapEventToState(
    FastRewardedAdBlocEvent event,
  ) async* {
    final type = event.type;
    final payload = event.payload;

    if (type == FastAdmobRewardedAdBlocEventType.init) {
      if (payload is FastRewardedAdBlocEventPayload) {
        yield* handleInitEvent(payload);
      }
    } else if (type == FastAdmobRewardedAdBlocEventType.initalized) {
      yield* handleInitializedEvent();
    } else if (isInitialized) {
      if (type == FastAdmobRewardedAdBlocEventType.loadAndShowAd) {
        yield* handleLoadAndShowAd();
      } else if (type == FastAdmobRewardedAdBlocEventType.adLoaded) {
        yield* handleAdLoaded();
      } else if (type == FastAdmobRewardedAdBlocEventType.adShowed) {
        yield* handleAdShowed();
      } else if (type == FastAdmobRewardedAdBlocEventType.earnedReward) {
        if (payload is FastRewardedAdBlocEventPayload) {
          yield* handleEarnedReward(payload);
        }
      } else if (type == FastAdmobRewardedAdBlocEventType.adDismissed) {
        yield* handleAdDismissed();
      } else if (type == FastAdmobRewardedAdBlocEventType.adLoadingError ||
          type == FastAdmobRewardedAdBlocEventType.adShowingError) {
        if (payload is FastRewardedAdBlocEventPayload) {
          yield* handleAdError(payload);
        }
      } else if (type == FastAdmobRewardedAdBlocEventType.cancelAdRequest) {
        yield* handleCancelAdRequestEvent();
      }
    } else {
      assert(false, 'FastAdmobRewardedAdBloc is not initialized yet.');
    }
  }

  Stream<FastRewardedAdBlocState> handleInitEvent(
    FastRewardedAdBlocEventPayload payload,
  ) async* {
    if (canInitialize) {
      assert(payload.adInfo != null);
      assert(payload.adInfo?.rewardedAdUnitId != null);

      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      blockDuration = payload.blockDuration ?? const Duration(minutes: 15);

      _admobService = FastAdmobRewardedAdService(payload.adInfo);
      _admobService.addListener(this);

      addEvent(const FastRewardedAdBlocEvent.initialized());
    }
  }

  Stream<FastRewardedAdBlocState> handleInitializedEvent() async* {
    if (isInitializing) {
      isInitialized = true;

      yield currentState.copyWith(
        isInitializing: false,
        isInitialized: true,
      );
    }
  }

  Stream<FastRewardedAdBlocState> handleLoadAndShowAd() async* {
    if (currentState.isLoadingAd) {
      debugLog(
        'Ad is already loading. Ignoring event.',
        debugLabel: debugLabel,
      );

      return;
    }

    // Reset state
    final emptyState = _getEmptyState();

    if (isRequestBlocked) {
      debugLog(
        'Ad request is blocked. Ignoring event.',
        debugLabel: debugLabel,
      );

      yield emptyState;

      addEvent(FastRewardedAdBlocEvent.adLoadingError(
        'Ad request is blocked. Ignoring event.',
      ));

      return;
    }

    final requestId = await _admobService.loadAd();

    yield emptyState.copyWith(
      error: requestId == null ? 'Failed to load ad' : null,
      isLoadingAd: requestId != null,
      requestId: requestId,
    );
  }

  Stream<FastRewardedAdBlocState> handleAdLoaded() async* {
    if (currentState.isLoadingAd && currentState.requestId != null) {
      yield currentState.copyWith(
        hasLoadedAd: true,
        isLoadingAd: false,
      );

      // Block requests for the specified duration
      _blockRequests();

      _admobService.showAdIfAvailable(currentState.requestId!);
    }
  }

  Stream<FastRewardedAdBlocState> handleAdShowed() async* {
    yield currentState.copyWith(isShowingAd: true);
  }

  Stream<FastRewardedAdBlocState> handleEarnedReward(
    FastRewardedAdBlocEventPayload payload,
  ) async* {
    yield currentState.copyWith(reward: payload.reward);
  }

  Stream<FastRewardedAdBlocState> handleAdDismissed() async* {
    yield currentState.copyWith(
      isShowingAd: false,
      hasDismissedAd: true,
      hasLoadedAd: false,
    );
  }

  Stream<FastRewardedAdBlocState> handleAdError(
    FastRewardedAdBlocEventPayload payload,
  ) async* {
    yield currentState.copyWith(
      error: payload.error,
      isLoadingAd: false,
      isShowingAd: false,
      hasLoadedAd: false,
    );
  }

  Stream<FastRewardedAdBlocState> handleCancelAdRequestEvent() async* {
    yield _getEmptyState();
  }

  @override
  void onAdLoaded(String requestId, RewardedAd ad) {
    if (_isRequestAllowed(requestId)) {
      addEvent(const FastRewardedAdBlocEvent.adLoaded());
    } else {
      handleOldRequestEvent('adLoaded');
    }
  }

  @override
  void onAdFailedToLoad(String requestId, LoadAdError error) {
    debugLog(requestId, debugLabel: debugLabel);

    if (_isRequestAllowed(requestId)) {
      addEvent(FastRewardedAdBlocEvent.adLoadingError(error));
    } else {
      handleOldRequestEvent('adFailedToLoad');
    }
  }

  @override
  void onAdFailedToShow(String requestId, AdError error) {
    if (_isRequestAllowed(requestId)) {
      addEvent(FastRewardedAdBlocEvent.adShowingError(error));
    } else {
      handleOldRequestEvent('adFailedToShow');
    }
  }

  @override
  void onAdShowed(String requestId, RewardedAd ad) {
    if (_isRequestAllowed(requestId)) {
      addEvent(const FastRewardedAdBlocEvent.adShowed());
    } else {
      handleOldRequestEvent('adShowed');
    }
  }

  @override
  void onUserEarnedReward(String requestId, RewardItem reward) {
    if (_isRequestAllowed(requestId)) {
      addEvent(FastRewardedAdBlocEvent.earnedReward(reward));
    } else {
      handleOldRequestEvent('earnedReward');
    }
  }

  @override
  void onAdDismissed(String requestId, RewardedAd ad) {
    if (_isRequestAllowed(requestId)) {
      addEvent(const FastRewardedAdBlocEvent.adDismissed());
    } else {
      handleOldRequestEvent('adDismissed');
    }
  }

  @override
  void onAdImpression(String requestId, RewardedAd ad) {
    // TODO: implement onAdImpression
    // analyticsService.logEvent(name: 'ad_impression');
  }

  @override
  void onAdClicked(String requestId, RewardedAd ad) {
    // TODO: implement onAdClicked
    // analyticsService.logEvent(name: 'ad_clicked');
  }

  @override
  void handleInternalError(dynamic error) {
    debugPrint(error.toString());
  }

  void handleOldRequestEvent(String type) {
    debugLog(
      'Received a $type event for an old request. Ignoring event.',
      debugLabel: debugLabel,
    );
  }

  void _blockRequests() {
    isRequestBlocked = true;
    blockTimer?.cancel();
    blockTimer = Timer(blockDuration, _unblockRequests);
  }

  void _unblockRequests() => isRequestBlocked = false;

  FastRewardedAdBlocState _getEmptyState() {
    return FastRewardedAdBlocState(isInitialized: true);
  }

  bool _isRequestAllowed(String requestId) {
    return requestId == currentState.requestId;
  }
}
