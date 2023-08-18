// Package imports:
import 'package:tbloc/tbloc.dart';
import 'package:tstore/tstore.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppDictBloc
    extends BidirectionalBloc<FastAppDictBlocEvent, FastAppDictBlocState> {
  static bool _hasBeenInstantiated = false;
  static late FastAppDictBloc instance;

  FastAppDictDataProvider _dataProvider;

  FastAppDictBloc._({FastAppDictBlocState? initialState})
      : _dataProvider = FastAppDictDataProvider(),
        super(initialState: initialState ?? FastAppDictBlocState());

  factory FastAppDictBloc({FastAppDictBlocState? initialState}) {
    if (!_hasBeenInstantiated) {
      instance = FastAppDictBloc._(initialState: initialState);
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  @override
  bool canClose() => false;

  T getValue<T>(String name) => currentState.getValue<T>(name);

  @override
  Stream<FastAppDictBlocState> mapEventToState(
    FastAppDictBlocEvent event,
  ) async* {
    final payload = event.payload;
    final type = event.type;

    if (type == FastAppDictBlocEventType.init) {
      yield* handleInitEvent();
    } else if (type == FastAppDictBlocEventType.initialized) {
      if (payload is List<FastDictEntryEntity>) {
        yield* handleInitializedEvent(payload);
      }
    } else if (isInitialized) {
      switch (type) {
        case FastAppDictBlocEventType.retrieveEntries:
          yield* handleRetrieveEntriesEvent();
        case FastAppDictBlocEventType.entriesRetrieved:
          if (payload is List<FastDictEntryEntity>) {
            yield* handleEntriesRetrievedEvent(payload);
          }
        case FastAppDictBlocEventType.deleteEntries:
          yield* handleDeleteEntriesEvent(payload);

        case FastAppDictBlocEventType.patchEnties:
          if (payload is List<FastDictEntryEntity>) {
            yield* handlePatchEntriesEvent(payload);
          }

        default:
          break;
      }
    } else {
      assert(false, 'FastAppDictBloc is not initialized yet.');
    }
  }

  Stream<FastAppDictBlocState> handleInitEvent() async* {
    if (canInitialize) {
      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);

      final entries = await _retrieveEntries();

      subxList.add(
        _dataProvider.onChanges.listen((TStoreChanges changes) {
          addEvent(const FastAppDictBlocEvent.retrieveEntries());
        }),
      );

      addEvent(FastAppDictBlocEvent.initialized(entries));
    }
  }

  Stream<FastAppDictBlocState> handleInitializedEvent(
    List<FastDictEntryEntity> entries,
  ) async* {
    if (isInitializing) {
      isInitialized = true;

      yield currentState.copyWith(
        isInitializing: false,
        isInitialized: true,
        entries: entries,
      );
    }
  }

  Stream<FastAppDictBlocState> handleRetrieveEntriesEvent() async* {
    if (isInitialized) {
      yield currentState.copyWith(isRetrievingEntries: true);

      final entries = await _retrieveEntries();

      addEvent(FastAppDictBlocEvent.entriesRetrieved(entries));
    }
  }

  Stream<FastAppDictBlocState> handleEntriesRetrievedEvent(
    List<FastDictEntryEntity> entries,
  ) async* {
    if (isInitialized) {
      yield currentState.copyWith(
        isRetrievingEntries: false,
        entries: entries,
      );
    }
  }

  Stream<FastAppDictBlocState> handlePatchEntriesEvent(
    List<FastDictEntryEntity> entries,
  ) async* {
    if (isInitialized) {
      _dataProvider.persistEntries(entries);

      addEvent(const FastAppDictBlocEvent.retrieveEntries());
    }
  }

  Stream<FastAppDictBlocState> handleDeleteEntriesEvent(
    List<FastDictEntryEntity>? entries,
  ) async* {
    if (isInitialized) {
      if (entries != null) {
        _dataProvider.deleteEntries(entries);
      } else {
        _dataProvider.deleteAllEntries();
      }

      addEvent(const FastAppDictBlocEvent.retrieveEntries());
    }
  }

  Future<List<FastDictEntryEntity>> _retrieveEntries() async {
    await _dataProvider.connect();

    return _dataProvider.listAllEntries();
  }
}
