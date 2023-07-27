// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

/// BLoC class for managing the display and control of a splash ad in a Flutter
/// application.
class FastSplashAdBloc
    extends BidirectionalBloc<FastSplashAdBlocEvent, FastSplashAdBlocState> {
  static FastSplashAdBloc? _singleton;

  late FastAdmobSplashAdService _service;
  late int _appLaunchCounter;

  /// Returns whether the ad can be shown based on the current state.
  bool get canShowAd {
    if (isInitialized) {
      final adInfo = currentState.adInfo;
      final threshold = adInfo.splashAdThreshold;

      return _appLaunchCounter > threshold;
    }

    return false;
  }

  factory FastSplashAdBloc({FastSplashAdBlocState? initialState}) {
    return (_singleton ??= FastSplashAdBloc._(initialState: initialState));
  }

  /// Constructor for initializing the [FastSplashAdBloc].
  ///
  /// The [super.initialState] is set to a default state with an empty
  /// [FastAddInfo].
  FastSplashAdBloc._({FastSplashAdBlocState? initialState})
      : super(initialState: initialState ?? FastSplashAdBlocState());

  @override
  bool canClose() => false;

  @override
  Stream<FastSplashAdBlocState> mapEventToState(
    FastSplashAdBlocEvent event,
  ) async* {
    final payload = event.payload;
    final type = event.type;

    if (type == FastSplashAdBlocEventType.init) {
      yield* handleInitEvent(payload);
    } else if (type == FastSplashAdBlocEventType.initialized) {
      yield* handleInitializedEvent(payload);
    } else if (isInitialized) {
      if (type == FastSplashAdBlocEventType.loadAd) {
        yield* handleLoadSplashAdEvent();
      } else if (type == FastSplashAdBlocEventType.showAd) {
        yield* handleShowSplashAdEvent();
      }
    } else {
      assert(false, 'FastSplashAdBloc is not initialized yet.');
    }
  }

  /// Initializes the ad manager and retrieves the splash ad document.
  Stream<FastSplashAdBlocState> handleInitEvent(
    FastSplashAdBlocEventPayload? payload,
  ) async* {
    if (canInitialize) {
      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      final adInfo = payload?.adInfo ?? currentState.adInfo;

      _service = FastAdmobSplashAdService(adInfo: adInfo);
      _appLaunchCounter = payload?.appLaunchCounter ?? 0;

      addEvent(FastSplashAdBlocEvent.initialized(payload: payload));
    }
  }

  /// Updates the state after initialization is completed.
  Stream<FastSplashAdBlocState> handleInitializedEvent(
    FastSplashAdBlocEventPayload? payload,
  ) async* {
    if (isInitializing) {
      isInitialized = true;

      yield currentState.copyWith(
        countryCode: payload?.countryCode,
        adInfo: payload?.adInfo,
        isInitializing: false,
        isInitialized: true,
      );
    }
  }

  /// Loads the splash ad.
  Stream<FastSplashAdBlocState> handleLoadSplashAdEvent() async* {
    if (canShowAd) _service.loadAd(country: currentState.countryCode);
  }

  /// Shows the splash ad.
  Stream<FastSplashAdBlocState> handleShowSplashAdEvent() async* {
    if (canShowAd) _service.showAdIfAvailable();
  }
}
