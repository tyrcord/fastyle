// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rxdart/rxdart.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastRewardedAdBloc
    extends BidirectionalBloc<FastRewardedAdBlocEvent, FastRewardedAdBlocState>
    implements AdEventListener {
  static String debugLabel = 'FastRewardedAdBloc';
  static FastRewardedAdBloc? _singleton;

  late final FastAdmobRewardedAdService _admobService;
  late final Duration blockDuration;

  final rewardController = PublishSubject<RewardItem>();

  Stream<RewardItem> get onReward => rewardController.stream;

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

    if (type == FastRewardedAdBlocEventType.init) {
      if (payload is FastRewardedAdBlocEventPayload) {
        yield* handleInitEvent(payload);
      }
    } else if (type == FastRewardedAdBlocEventType.initalized) {
      yield* handleInitializedEvent();
    } else if (isInitialized) {
      if (type == FastRewardedAdBlocEventType.loadAndShowAd) {
        yield* handleLoadAndShowAd();
      } else if (type == FastRewardedAdBlocEventType.adLoaded) {
        yield* handleAdLoaded();
      } else if (type == FastRewardedAdBlocEventType.adShowed) {
        yield* handleAdShowed();
      } else if (type == FastRewardedAdBlocEventType.earnedReward) {
        if (payload is FastRewardedAdBlocEventPayload) {
          yield* handleEarnedReward(payload);
        }
      } else if (type == FastRewardedAdBlocEventType.adDismissed) {
        yield* handleAdDismissed();
      } else if (type == FastRewardedAdBlocEventType.adLoadingError ||
          type == FastRewardedAdBlocEventType.adShowingError) {
        if (payload is FastRewardedAdBlocEventPayload) {
          yield* handleAdError(payload);
        }
      } else if (type == FastRewardedAdBlocEventType.clearAndCancelAdRequest) {
        yield* handleClearAndCancelAdRequest();
      }
    } else {
      assert(false, 'FastRewardedAdBloc is not initialized yet.');
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
    debugLog('Loading ad...', debugLabel: debugLabel);

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
        FastRewardedAdBlocError.noAdAvailable,
      ));

      return;
    }

    final requestId = await _admobService.loadAd();

    debugLog('Ad requested. Request id: $requestId', debugLabel: debugLabel);

    yield emptyState.copyWith(
      error: requestId == null ? FastRewardedAdBlocError.adFailedToLoad : null,
      isLoadingAd: requestId != null,
      requestId: requestId,
    );
  }

  Stream<FastRewardedAdBlocState> handleAdLoaded() async* {
    if (currentState.isLoadingAd && currentState.requestId != null) {
      debugLog(
        'Ad loaded. Request id: ${currentState.requestId}',
        debugLabel: debugLabel,
      );

      yield currentState.copyWith(
        hasLoadedAd: true,
        isLoadingAd: false,
      );

      _admobService.showAdIfAvailable(currentState.requestId!);
    }
  }

  Stream<FastRewardedAdBlocState> handleAdShowed() async* {
    debugLog(
      'Ad showed. Request id: ${currentState.requestId}',
      debugLabel: debugLabel,
    );

    yield currentState.copyWith(isShowingAd: true);
  }

  Stream<FastRewardedAdBlocState> handleEarnedReward(
    FastRewardedAdBlocEventPayload payload,
  ) async* {
    debugLog(
      'Ad earned reward. Request id: ${currentState.requestId}',
      debugLabel: debugLabel,
    );

    if (payload.reward != null) {
      rewardController.add(payload.reward!);
    }
  }

  Stream<FastRewardedAdBlocState> handleAdDismissed() async* {
    debugLog(
      'Ad dismissed. Request id: ${currentState.requestId}',
      debugLabel: debugLabel,
    );

    // Block requests for the specified duration
    _blockRequests();

    yield currentState.copyWith(
      hasDismissedAd: true,
      isShowingAd: false,
      isLoadingAd: false,
      hasLoadedAd: false,
    );
  }

  Stream<FastRewardedAdBlocState> handleAdError(
    FastRewardedAdBlocEventPayload payload,
  ) async* {
    debugLog(
      'Ad error: ${payload.error}. Request id: ${currentState.requestId}',
      debugLabel: debugLabel,
    );

    yield currentState.copyWith(
      error: payload.error,
      hasDismissedAd: false,
      isShowingAd: false,
      isLoadingAd: false,
      hasLoadedAd: false,
    );
  }

  Stream<FastRewardedAdBlocState> handleClearAndCancelAdRequest() async* {
    debugLog(
      'Ad request canceled. Request id: ${currentState.requestId}',
      debugLabel: debugLabel,
    );

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

    if (kDebugMode) {
      final now = DateTime.now();

      debugLog(
        'Blocking ad requests for ${blockDuration.inSeconds} seconds.',
        debugLabel: debugLabel,
      );

      debugLog(
        'Unblocking ad requests at ${now.add(blockDuration).toIso8601String()}',
        debugLabel: debugLabel,
      );
    }
  }

  void _unblockRequests() => isRequestBlocked = false;

  FastRewardedAdBlocState _getEmptyState() {
    return FastRewardedAdBlocState(isInitialized: true);
  }

  bool _isRequestAllowed(String requestId) {
    return requestId == currentState.requestId;
  }
}
