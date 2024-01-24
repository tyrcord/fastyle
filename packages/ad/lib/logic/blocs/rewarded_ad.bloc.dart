// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rxdart/rxdart.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

/// BLoC class for managing rewarded ads with AdMob integration.
class FastRewardedAdBloc
    extends BidirectionalBloc<FastRewardedAdBlocEvent, FastRewardedAdBlocState>
    implements AdEventListener {
  /// Keeps track if a singleton instance has been created.
  static bool get hasBeenInstantiated => _hasBeenInstantiated;
  static bool _hasBeenInstantiated = false;

  static final _logger = TLoggerManager.instance.getLogger(debugLabel);
  static const debugLabel = 'FastRewardedAdBloc';

  static late FastRewardedAdBloc _instance;

  static FastRewardedAdBloc get instance {
    if (!_hasBeenInstantiated) return FastRewardedAdBloc();

    return _instance;
  }

  // Method to reset the singleton instance
  static void reset() => _hasBeenInstantiated = false;

  late final FastAdmobRewardedAdService _admobService;
  late final Duration blockDuration;

  final rewardController = PublishSubject<RewardItem>();

  /// Stream to listen for earned rewards.
  Stream<RewardItem> get onReward => rewardController.stream;

  bool isRequestBlocked = false;
  Timer? blockTimer;

  /// Factory constructor to create an instance of [FastRewardedAdBloc].
  factory FastRewardedAdBloc({FastRewardedAdBlocState? initialState}) {
    if (!_hasBeenInstantiated) {
      _instance = FastRewardedAdBloc._(initialState: initialState);
      _hasBeenInstantiated = true;
    }

    return instance;
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

    _logger.debug('Event received: $type');

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

  /// Handles the init event and initializes the BLoC.
  Stream<FastRewardedAdBlocState> handleInitEvent(
    FastRewardedAdBlocEventPayload payload,
  ) async* {
    if (canInitialize) {
      assert(payload.adInfo != null);
      assert(payload.adInfo?.rewardedAdUnitId != null);

      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      blockDuration = payload.blockDuration ?? kFastAdRewardedBlockDuration;

      _admobService = FastAdmobRewardedAdService(payload.adInfo);
      _admobService.addListener(this);

      addEvent(const FastRewardedAdBlocEvent.initialized());
    }
  }

  /// Handles the initialized event after successful initialization.
  Stream<FastRewardedAdBlocState> handleInitializedEvent() async* {
    if (isInitializing) {
      isInitialized = true;

      yield currentState.copyWith(
        isInitializing: false,
        isInitialized: true,
      );
    }
  }

  /// Handles the event to load and show the rewarded ad.
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

  /// Handles the event when an ad is successfully loaded.
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

  /// Handles the event when an ad is successfully showed.
  Stream<FastRewardedAdBlocState> handleAdShowed() async* {
    debugLog(
      'Ad showed. Request id: ${currentState.requestId}',
      debugLabel: debugLabel,
    );

    yield currentState.copyWith(isShowingAd: true);
  }

  /// Handles the event when an earned reward is received.
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

  /// Handles the event when an ad is dismissed.
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

  /// Handles the event when an ad loading or showing error occurs.
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

  /// Handles the event to clear and cancel an ad request.
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
  void handleInternalError(dynamic error, StackTrace stackTrace) {
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
