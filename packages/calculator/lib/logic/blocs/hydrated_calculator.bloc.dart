// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

/// An abstract class that extends [FastCalculatorBloc] to create a hydrated
/// calculator bloc.
///
/// This hydrated calculator bloc can persist its state and recover from it
/// when needed.
///
/// The class requires the following generic types:
///   E: The type of events that the bloc responds to
///   (must extend [FastCalculatorBlocEvent]).
///
///   S: The type of state that the bloc manages
///  (must extend [FastCalculatorBlocState]).
///
///   D: The type of calculator document used to persist the state
///   (must extend [FastCalculatorDocument]).
///
///   R: The type of calculator results managed by the bloc
///   (must extend [FastCalculatorResults]).
abstract class HydratedFastCalculatorBloc<
    E extends FastCalculatorBlocEvent,
    S extends FastCalculatorBlocState,
    D extends FastCalculatorDocument,
    R extends FastCalculatorResults> extends FastCalculatorBloc<E, S, R> {
  /// The [dataProvider] is used to persist the calculator document.
  @protected
  final FastCalculatorDataProvider<D> dataProvider;

  late FastCalculatorBlocDebounceEventCallback<E> addDebouncedSaveEntryEvent;

  /// The [defaultDocument] is used to hydrate the bloc calculator state.
  @protected
  late D defaultDocument;

  /// The [document] is used to hydrate the bloc calculator state.
  @protected
  late D document;

  HydratedFastCalculatorBloc({
    required super.initialState,
    required this.dataProvider,
    super.debugLabel,
    super.debouceComputeEvents,
  }) {
    addDebouncedSaveEntryEvent = debounceEvent((event) => addEvent(event));
  }

  /// Retrieves the default calculator document.
  ///
  /// This method should be implemented by the subclass.
  /// It is called when the bloc is initialized and should return
  /// the default calculator document.
  /// Contains the default values for the calculator state.
  @protected
  Future<D> retrieveDefaultCalculatorDocument();

  /// Patches the calculator document with the given [key] and [value].
  ///
  /// This method should be implemented by the subclass.
  @protected
  Future<D?> patchCalculatorDocument(String key, dynamic value);

  /// Determines if the user entry can be saved.
  ///
  /// Returns a [Future] that resolves to `true` if the user entry can be saved,
  /// otherwise `false`. By default, it returns `true`.
  @protected
  Future<bool> canSaveUserEntry() async => true;

  /// Closes the bloc by disconnecting from the data provider.
  ///
  /// This method is called when the bloc is no longer needed and
  /// should perform cleanup tasks, such as disconnecting from the
  /// data provider.
  @override
  @mustCallSuper
  void close() {
    debugLog('closing calculator bloc...', debugLabel: debugLabel);
    super.close();
    dataProvider.disconnect();
  }

  /// Initializes the bloc by connecting to the data provider and
  /// retrieving the default and saved calculator documents.
  ///
  /// This method is called when the bloc is created and sets up the
  /// initial state for the bloc.
  @override
  @mustCallSuper
  Future<void> initialize() async {
    debugLog('initializing calculator bloc...', debugLabel: debugLabel);
    await dataProvider.connect();

    defaultDocument = await retrieveDefaultCalculatorDocument();
    debugLog(
      'retrieved default calculator bloc document',
      value: defaultDocument,
      debugLabel: debugLabel,
    );

    document = await retrieveCalculatorDocument();
    debugLog(
      'will use calculator bloc document',
      value: document,
      debugLabel: debugLabel,
    );
  }

  /// Initializes the calculator state with the calculator document.
  ///
  /// This method is called after the bloc is initialized and
  /// the calculator documents are retrieved.
  @override
  @mustCallSuper
  Future<S> initializeCalculatorState() async {
    return initialState!.copyWith(fields: document.toFields()) as S;
  }

  /// Saves the calculator state by persisting the calculator document.
  ///
  /// This method is called after the calculator state is modified.
  @override
  @mustCallSuper
  Future<bool> saveCalculatorState() async {
    await persistCalculatorDocument();

    return super.saveCalculatorState();
  }

  /// Clears the calculator state by clearing the calculator document.
  ///
  /// This method is called when the calculator state needs to be reset.
  @override
  @mustCallSuper
  Future<S> clearCalculatorState() async {
    await clearCalculatorDocument();
    document = await retrieveCalculatorDocument();

    return super.clearCalculatorState();
  }

  /// Retrieves the calculator document by merging the saved document
  /// with the default calculator document.
  ///
  /// This method is called when the bloc is initialized.
  @protected
  Future<D> retrieveCalculatorDocument() async {
    if (await canSaveUserEntry()) {
      final savedDocument = await dataProvider.retrieveCalculatorDocument();
      debugLog(
        'retrieved saved calculator bloc document',
        value: savedDocument,
        debugLabel: debugLabel,
      );

      return defaultDocument.merge(savedDocument) as D;
    }

    return defaultDocument;
  }

  /// Persists the calculator document.
  ///
  /// This method is called when the calculator state is saved.
  @protected
  Future<void> persistCalculatorDocument({bool force = false}) async {
    if (force || await canSaveUserEntry()) {
      debugLog(
        'persisting calculator bloc document',
        value: document.toJson(),
        debugLabel: debugLabel,
      );

      return dataProvider.persistCalculatorDocument(document);
    }
  }

  /// Clears the calculator document.
  ///
  /// This method is called when the calculator state is cleared.
  @protected
  Future<void> clearCalculatorDocument({bool force = false}) async {
    if (force || await canSaveUserEntry()) {
      debugLog('clearing calculator bloc document', debugLabel: debugLabel);

      return dataProvider.clearCalculatorDocument();
    }
  }

  @override
  @protected
  void handleSettingsChanges(FastAppSettingsBlocState state) {
    super.handleSettingsChanges(state);

    if (isInitialized) {
      debugLog('Settings changed, checking save entry', debugLabel: debugLabel);
      addDebouncedSaveEntryEvent(
        FastCalculatorBlocEvent.saveEntryChanged<R>() as E,
      );
    }
  }

  /// Maps the events to the corresponding state changes in the bloc.
  ///
  /// This method handles events like patching values and calculating results.
  /// It is responsible for updating the state in response to events.
  ///
  /// [event]: The event to be handled by the bloc.
  @override
  @protected
  Stream<S> mapEventToState(FastCalculatorBlocEvent event) async* {
    final payload = event.payload;
    final eventType = event.type;
    final saveUserEntry = await canSaveUserEntry();

    if (saveUserEntry &&
        eventType == FastCalculatorBlocEventType.patchValue &&
        payload != null &&
        payload.key != null) {
      yield* handlePatchValueEvent(payload);
    } else if (eventType == FastCalculatorBlocEventType.retrieveDefaultValues) {
      defaultDocument = await retrieveDefaultCalculatorDocument();
      defaultCalculatorState = await initializeDefaultCalculatorState();
    } else if (eventType == FastCalculatorBlocEventType.saveEntryChanged) {
      if (saveUserEntry) {
        await persistCalculatorDocument();
      } else {
        await clearCalculatorDocument(force: true);
      }
    } else {
      yield* super.mapEventToState(event);
    }
  }

  /// Handles the patch value event by updating the calculator state
  /// and document with the given [payload].
  @override
  @protected
  Stream<S> handlePatchValueEvent(
    covariant FastCalculatorBlocEventPayload payload,
  ) async* {
    final key = payload.key!;
    final value = payload.value;
    final state = await patchCalculatorState(key, value);

    if (state != null) {
      debugLog(
        'Patching calculator document with key: $key and value: $value',
        debugLabel: debugLabel,
      );

      final newDocument = await patchCalculatorDocument(key, value);

      if (newDocument != null) {
        document = newDocument;
      }

      await saveCalculatorState();
      yield state;

      if (debouceComputeEvents) {
        addDebouncedComputeEvent(FastCalculatorBlocEvent.compute<R>() as E);
      } else {
        addEvent(FastCalculatorBlocEvent.compute<R>() as E);
      }
    }
  }
}
