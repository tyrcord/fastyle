// Package imports:
import 'package:tbloc/tbloc.dart';
import 'package:tstore/tstore.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppDictBloc
    extends BidirectionalBloc<FastAppDictBlocEvent, FastAppDictBlocState> {
  static FastAppDictBloc? _singleton;
  FastAppDictDataProvider _dataProvider;

  FastAppDictBloc._({FastAppDictBlocState? initialState})
      : _dataProvider = FastAppDictDataProvider(),
        super(initialState: initialState ?? FastAppDictBlocState());

  factory FastAppDictBloc({FastAppDictBlocState? initialState}) {
    _singleton ??= FastAppDictBloc._(initialState: initialState);

    return _singleton!;
  }

  @override
  bool canClose() => false;

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
          yield* handleDeleteEntriesEvent();
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

  Stream<FastAppDictBlocState> handleDeleteEntriesEvent() async* {
    if (isInitialized) {
      await _deleteEntries();

      addEvent(const FastAppDictBlocEvent.retrieveEntries());
    }
  }

  Future<List<FastDictEntryEntity>> _retrieveEntries() async {
    await _dataProvider.connect();

    return _dataProvider.listAllEntries();
  }

  Future<void> _deleteEntries() async {
    await _dataProvider.deleteAllEntries();
  }
}
