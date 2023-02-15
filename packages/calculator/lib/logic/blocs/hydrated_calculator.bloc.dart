import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:flutter/material.dart';

abstract class HydratedFastCalculatorBloc<
    E extends FastCalculatorBlocEvent,
    S extends FastCalculatorBlocState,
    D extends FastCalculatorDocument,
    R extends FastCalculatorResults> extends FastCalculatorBloc<E, S, R> {
  /// The data provider is used to persist the calculator document.
  @protected
  final FastCalculatorDataProvider<D> dataProvider;

  /// The default calculator document is used to hydrate
  /// the bloc calculator state.
  @protected
  late D defaultDocument;

  /// The calculator document is used to hydrate the bloc calculator state.
  @protected
  late D document;

  HydratedFastCalculatorBloc({
    required super.initialState,
    required this.dataProvider,
    super.debugLabel,
  });

  /// This function is called when the bloc is initialized.
  /// It should return the default calculator document.
  /// This document will be used to hydrate the bloc calculator state.
  @protected
  Future<D> retrieveDefaultCalculatorDocument();

  /// Patches the calculator document with the given key and value.
  @protected
  Future<D?> patchCalculatorDocument(String key, dynamic value);

  @protected
  Future<bool> canSaveUserEntry() async => true;

  @override
  void close() {
    super.close();
    dataProvider.disconnect();
  }

  @override
  @mustCallSuper
  Future<void> initialize() async {
    log('initializing calculator bloc...');
    await dataProvider.connect();

    defaultDocument = await retrieveDefaultCalculatorDocument();
    log('retrieved default calculator bloc document', value: defaultDocument);

    document = await retrieveCalculatorDocument();
    log('will use calculator bloc document', value: document);
  }

  @override
  @mustCallSuper
  Future<S> initializeCalculatorState() async {
    return initialState!.copyWith(fields: document.toFields()) as S;
  }

  @override
  @mustCallSuper
  Future<bool> saveCalculatorState() async {
    await persistCalculatorDocument();

    return super.saveCalculatorState();
  }

  @override
  @mustCallSuper
  Future<S> clearCalculatorState() async {
    await clearCalculatorDocument();
    document = await retrieveCalculatorDocument();

    return super.clearCalculatorState();
  }

  /// This function is called when the bloc is initialized.
  /// It should return the default calculator document.
  /// This document will be merged with the default one
  /// and used to hydrate the bloc calculator state.
  @protected
  Future<D> retrieveCalculatorDocument() async {
    if (await canSaveUserEntry()) {
      final savedDocument = await dataProvider.retrieveCalculatorDocument();
      log('retrieved saved calculator bloc document', value: savedDocument);

      return defaultDocument.merge(savedDocument) as D;
    }

    return defaultDocument;
  }

  @protected
  Future<void> persistCalculatorDocument() async {
    if (await canSaveUserEntry()) {
      log('persisting calculator bloc document', value: document.toJson());

      return dataProvider.persistCalculatorDocument(document);
    }
  }

  @protected
  Future<void> clearCalculatorDocument() async {
    if (await canSaveUserEntry()) {
      return dataProvider.clearCalculatorDocument();
    }
  }

  @override
  Stream<S> mapEventToState(FastCalculatorBlocEvent event) async* {
    final payload = event.payload;
    final eventType = event.type;
    final saveUserEntry = await canSaveUserEntry();

    if (saveUserEntry &&
        eventType == FastCalculatorBlocEventType.patchValue &&
        payload != null &&
        payload.key != null) {
      yield* handlePatchValueEvent(payload);
    } else {
      yield* super.mapEventToState(event);
    }
  }

  @override
  @protected
  Stream<S> handlePatchValueEvent(
    FastCalculatorBlocEventPayload payload,
  ) async* {
    final key = payload.key!;
    final value = payload.value;
    var state = await patchCalculatorState(key, value);

    if (state != null) {
      log('Patching calculator document with key: $key and value: $value');

      final newDocument = await patchCalculatorDocument(key, value);

      if (newDocument != null) {
        document = newDocument;
      }

      await saveCalculatorState();
      yield state;

      addDebounceEvent(FastCalculatorBlocEvent.compute<R>() as E);
    }
  }
}
