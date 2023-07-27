import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tbloc/tbloc.dart';
import 'package:fastyle_ad/fastyle_ad.dart';

class FastRewardedAdBloc
    extends BidirectionalBloc<FastRewardedAdBlocEvent, FastRewardedAdBlocState>
    implements AdEventListener {
  static FastRewardedAdBloc? _singleton;
  late final FastAdmobRewardedAdService _admobService;

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
      } else if (type == FastAdmobRewardedAdBlocEventType.showAd) {
        yield* handleShowAd();
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

  /// TODO: avoid requesting ads too frequently
  Stream<FastRewardedAdBlocState> handleLoadAndShowAd() async* {
    // Reset state
    yield FastRewardedAdBlocState(isInitialized: true, isLoadingAd: true);

    await _admobService.loadAd();
  }

  Stream<FastRewardedAdBlocState> handleAdLoaded() async* {
    if (currentState.isLoadingAd) {
      yield currentState.copyWith(
        hasLoadedAd: true,
        isLoadingAd: false,
      );

      addEvent(const FastRewardedAdBlocEvent.showAd());
    }
  }

  Stream<FastRewardedAdBlocState> handleShowAd() async* {
    if (currentState.hasLoadedAd) {
      _admobService.showAdIfAvailable();
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

  @override
  void onAdLoaded(RewardedAd ad) {
    addEvent(const FastRewardedAdBlocEvent.adLoaded());
  }

  @override
  void onAdFailedToLoad(LoadAdError error) {
    addEvent(FastRewardedAdBlocEvent.adLoadingError(error));
  }

  @override
  void onAdFailedToShow(AdError error) {
    addEvent(FastRewardedAdBlocEvent.adShowingError(error));
  }

  @override
  void onAdShowed() {
    addEvent(const FastRewardedAdBlocEvent.adShowed());
  }

  @override
  void onUserEarnedReward(RewardItem reward) {
    addEvent(FastRewardedAdBlocEvent.earnedReward(reward));
  }

  @override
  void onAdDismissed() {
    addEvent(const FastRewardedAdBlocEvent.adDismissed());
  }

  @override
  void onAdImpression() {
    // TODO: implement onAdImpression
    // analyticsService.logEvent(name: 'ad_impression');
  }

  @override
  void onAdClicked() {
    // TODO: implement onAdClicked
    // analyticsService.logEvent(name: 'ad_clicked');
  }

  @override
  void handleInternalError(dynamic error) {
    debugPrint(error.toString());
  }
}
