// Dart imports:
import 'dart:async';

// Package imports:
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

/// BLoC class for managing the display and control of a splash ad in a Flutter
/// application.
class FastSplashAdBloc
    extends BidirectionalBloc<FastSplashAdBlocEvent, FastSplashAdBlocState> {
  /// Keeps track if a singleton instance has been created.
  static bool get hasBeenInstantiated => _hasBeenInstantiated;
  static bool _hasBeenInstantiated = false;

  static final _logger = TLoggerManager.instance.getLogger(debugLabel);
  static const debugLabel = 'FastSplashAdBloc';

  static late FastSplashAdBloc _instance;

  static FastSplashAdBloc get instance {
    if (!_hasBeenInstantiated) return FastSplashAdBloc();

    return _instance;
  }

  // Method to reset the singleton instance
  static void reset() => instance.resetBloc();

  static final _dataProvider = FastSplashAdDataProvider();

  FastAdmobSplashAdService? _service;
  int _appLaunchCounter = 0;

  StreamSubscription<DateTime>? _serviceSubscription;

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
    if (!_hasBeenInstantiated) {
      _instance = FastSplashAdBloc._(initialState: initialState);
      _hasBeenInstantiated = true;
    }

    return instance;
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

    _logger.debug('Event received: $type');

    if (type == FastSplashAdBlocEventType.init) {
      yield* handleInitEvent(payload);
    } else if (type == FastSplashAdBlocEventType.initialized) {
      yield* handleInitializedEvent(payload);
    } else if (isInitialized) {
      if (type == FastSplashAdBlocEventType.loadAd) {
        yield* handleLoadSplashAdEvent();
      } else if (type == FastSplashAdBlocEventType.showAd) {
        yield* handleShowSplashAdEvent();
      } else if (type == FastSplashAdBlocEventType.adImpression) {
        if (payload is FastSplashAdBlocEventPayload) {
          yield* handleAdImpressionEvent(payload);
        }
      }
    }
  }

  /// Initializes the ad manager and retrieves the splash ad document.
  Stream<FastSplashAdBlocState> handleInitEvent(
    FastSplashAdBlocEventPayload? payload,
  ) async* {
    if (canInitialize) {
      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      if (_serviceSubscription != null) _serviceSubscription!.cancel();

      final adInfo = payload?.adInfo ?? currentState.adInfo;
      final document = await _retrieveDocument();

      _service = FastAdmobSplashAdService(adInfo: adInfo);
      _appLaunchCounter = payload?.appLaunchCounter ?? 0;

      payload = payload?.copyWith(
        lastImpressionDate: document.lastImpressionDate,
      );

      _logger.debug('lastImpressionDate: ${payload?.lastImpressionDate}');

      subxList.add(
        _service!.onAdImpression.listen((date) {
          addEvent(FastSplashAdBlocEvent.adImpression(date));
        }),
      );

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
        lastImpressionDate: payload?.lastImpressionDate,
        countryCode: payload?.countryCode,
        adInfo: payload?.adInfo,
        isInitializing: false,
        isInitialized: true,
      );
    }
  }

  /// Loads the splash ad.
  Stream<FastSplashAdBlocState> handleLoadSplashAdEvent() async* {
    yield currentState.copyWith(
      isAdLoaded: false,
      isAdLoading: true,
    );

    var isAdDisplayable = false;

    if (canShowAd) isAdDisplayable = await _service!.loadAd();

    yield currentState.copyWith(
      isAdDisplayable: isAdDisplayable,
      isAdLoading: false,
      isAdLoaded: true,
    );
  }

  /// Shows the splash ad.
  Stream<FastSplashAdBlocState> handleShowSplashAdEvent() async* {
    if (canShowAd) _service!.showAdIfAvailable();

    yield currentState.copyWith(isAdLoaded: false, isAdDisplayable: false);
  }

  /// Updates the state after an ad impression.
  Stream<FastSplashAdBlocState> handleAdImpressionEvent(
    FastSplashAdBlocEventPayload payload,
  ) async* {
    final document = await _retrieveDocument();
    final lastImpressionDate =
        payload.lastImpressionDate ?? DateTime.now().toUtc();

    _logger.debug('Ad impression: $lastImpressionDate');

    await _dataProvider.persistSplashAdDocument(
      document.copyWith(lastImpressionDate: lastImpressionDate),
    );

    yield currentState.copyWith(lastImpressionDate: lastImpressionDate);
  }

  Future<FastSplashAdDocument> _retrieveDocument() async {
    await _dataProvider.connect();

    return _dataProvider.retrieveSplashAdDocument();
  }
}
