// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastAdInfoBloc
    extends BidirectionalBloc<FastAdInfoBlocEvent, FastAdInfoBlocState> {
  static final FastAdConsentService _consentService =
      FastAdConsentService.instance;
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static final _manager = TLoggerManager();
  static const _debugLabel = 'FastAdInfoBloc';
  static bool _hasBeenInstantiated = false;
  static late FastAdInfoBloc instance;

  factory FastAdInfoBloc({FastAdInfoBlocState? initialState}) {
    if (!_hasBeenInstantiated) {
      instance = FastAdInfoBloc._(initialState: initialState);
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  FastAdInfoBloc._({FastAdInfoBlocState? initialState})
      : super(initialState: initialState ?? FastAdInfoBlocState());

  @override
  bool canClose() => false;

  @override
  Stream<FastAdInfoBlocState> mapEventToState(
    FastAdInfoBlocEvent event,
  ) async* {
    final payload = event.payload;
    final type = event.type;

    if (type == FastAdInfoBlocEventType.init) {
      yield* handleInitEvent(payload?.adInfo);
    } else if (type == FastAdInfoBlocEventType.initialized) {
      yield* handleInitializedEvent(payload?.adInfo);
    } else if (isInitialized) {
      if (type == FastAdInfoBlocEventType.askForConsent) {
        yield* handleAskForConsentEvent();
      } else if (type == FastAdInfoBlocEventType.constentStatusChanged) {
        yield* handleConsentStatusChangedEvent(payload?.consentStatus);
      } else if (type == FastAdInfoBlocEventType.askForConsentIfNedded) {
        yield* handleAskForConsentEventIfNeeded();
      } else {
        assert(false, 'Unknown event type: $type');
      }
    } else {
      assert(false, 'FastAdInfoBloc is not initialized yet.');
    }
  }

  Stream<FastAdInfoBlocState> handleInitEvent(FastAdInfo? adInfo) async* {
    if (canInitialize) {
      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      final consentStatus = await _consentService.getConsentStatus();
      _logger.info('GDPR consent status', consentStatus);

      await MobileAds.instance.initialize();
      await FastAd.initialize();

      isInitializing = false;
      isInitialized = true;

      yield currentState.copyWith(
        consentStatus: consentStatus,
        isInitializing: false,
        isInitialized: true,
        adInfo: adInfo,
      );
    }
  }

  Stream<FastAdInfoBlocState> handleInitializedEvent(
    FastAdInfo? adInfo,
  ) async* {
    if (isInitializing) {
      isInitialized = true;

      yield currentState.copyWith(
        isInitializing: false,
        isInitialized: true,
        adInfo: adInfo,
      );
    }
  }

  Stream<FastAdInfoBlocState> handleAskForConsentEvent() async* {
    if (isInitialized) {
      await FastAdConsentService.instance.showConsentForm();

      final consentStatus = await _consentService.getConsentStatus();

      if (consentStatus == ConsentStatus.unknown) {
        addEvent(FastAdInfoBlocEvent.constentStatusChanged(consentStatus));
      }
    }
  }

  Stream<FastAdInfoBlocState> handleAskForConsentEventIfNeeded() async* {
    if (isInitialized) {
      await FastAdConsentService.instance.showConsentFormIfNeeded();

      final consentStatus = await _consentService.getConsentStatus();

      if (consentStatus == ConsentStatus.unknown) {
        addEvent(FastAdInfoBlocEvent.constentStatusChanged(consentStatus));
      }
    }
  }

  Stream<FastAdInfoBlocState> handleConsentStatusChangedEvent(
    ConsentStatus? consentStatus,
  ) async* {
    if (isInitialized) {
      yield currentState.copyWith(consentStatus: consentStatus);
    }
  }
}
