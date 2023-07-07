import 'package:fastyle_core/fastyle_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tbloc/tbloc.dart';

class FastAppInfoBloc
    extends BidirectionalBloc<FastAppInfoBlocEvent, FastAppInfoBlocState> {
  static FastAppInfoBloc? _singleton;
  FastAppInfoDataProvider _dataProvider;

  FastAppInfoBloc._({FastAppInfoBlocState? initialState})
      : _dataProvider = FastAppInfoDataProvider(),
        super(initialState: initialState ?? FastAppInfoBlocState());

  factory FastAppInfoBloc({FastAppInfoBlocState? initialState}) {
    _singleton ??= FastAppInfoBloc._(initialState: initialState);

    return _singleton!;
  }

  @override
  bool canClose() => false;

  @override
  Stream<FastAppInfoBlocState> mapEventToState(
    FastAppInfoBlocEvent event,
  ) async* {
    final payload = event.payload;
    final type = event.type;

    if (type == FastAppInfoBlocEventType.init) {
      if (payload is FastAppInfoDocument) {
        yield* handleInitEvent(payload);
      }
    } else if (type == FastAppInfoBlocEventType.initialized) {
      if (payload is FastAppInfoDocument) {
        yield* handleInitializedEvent(payload);
      }
    } else {
      assert(false, 'FastAppInfoBloc is not initialized yet.');
    }
  }

  Stream<FastAppInfoBlocState> handleInitEvent(
    FastAppInfoDocument initialDocument,
  ) async* {
    if (canInitialize) {
      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      final persistedDocument = await _retrievePersistedAppInfo();
      final packageInfo = await PackageInfo.fromPlatform();

      var document = persistedDocument;

      // If the app is launched for the first time, we initialize the persisted
      // document with the initial document.
      // The initial document is the provided by the app.
      if (persistedDocument.appLaunchCounter == 0) {
        document = initialDocument;
      }

      document = document.copyWith(
        previousDatabaseVersion: persistedDocument.databaseVersion,
        databaseVersion: initialDocument.databaseVersion,
        appBuildNumber: packageInfo.buildNumber,
        appVersion: packageInfo.version,
      );

      addEvent(FastAppInfoBlocEvent.initialized(document));
    }
  }

  Stream<FastAppInfoBlocState> handleInitializedEvent(
    FastAppInfoDocument document,
  ) async* {
    if (isInitializing) {
      isInitialized = true;

      final nextDocument = document.copyWith(
        appLaunchCounter: document.appLaunchCounter + 1,
      );

      await _dataProvider.persistAppInfo(nextDocument);

      final tmpState = FastAppInfoBlocState.fromDocument(nextDocument);

      yield currentState.merge(tmpState).copyWith(
            isInitializing: false,
            isInitialized: true,
          );
    }
  }

  Future<FastAppInfoDocument> _retrievePersistedAppInfo() async {
    return _dataProvider.retrieveAppInfo();
  }
}
