import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:tbloc/tbloc.dart';
import 'package:fastyle_ad/fastyle_ad.dart';

class FastAdInfoBloc
    extends BidirectionalBloc<FastAdInfoBlocEvent, FastAdInfoBlocState> {
  static FastAdInfoBloc? _singleton;

  factory FastAdInfoBloc({FastAdInfoBlocState? initialState}) {
    _singleton ??= FastAdInfoBloc._(initialState: initialState);

    return _singleton!;
  }

  FastAdInfoBloc._({FastAdInfoBlocState? initialState})
      : super(initialState: initialState ?? FastAdInfoBlocState());

  @override
  Stream<FastAdInfoBlocState> mapEventToState(
    FastAdInfoBlocEvent event,
  ) async* {
    final adInfo = event.payload;
    final type = event.type;

    if (type == FastAdInfoBlocEventType.init) {
      yield* handleInitEvent(adInfo);
    } else if (type == FastAdInfoBlocEventType.initialized) {
      yield* handleInitializedEvent(adInfo);
    } else {
      assert(false, 'FastAdInfoBloc is not initialized yet.');
    }
  }

  Stream<FastAdInfoBlocState> handleInitEvent(FastAdInfo? adInfo) async* {
    if (canInitialize) {
      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      await MobileAds.instance.initialize();
      await FastAd.initialize();

      isInitializing = false;
      isInitialized = true;

      yield currentState.copyWith(
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
}
