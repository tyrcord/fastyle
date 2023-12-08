// Package imports:
import 'package:flutter/material.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

class FastCalculatorBlocEvent<R extends FastCalculatorResults>
    extends BlocEvent<FastCalculatorBlocEventType,
        FastCalculatorBlocEventPayload<R>> {
  const FastCalculatorBlocEvent({
    required FastCalculatorBlocEventType super.type, // The type of the event.
    super.payload, // An optional payload associated with the event.
  });

  // Returns an event with the type `FastCalculatorBlocEventType.init`
  // and no payload.
  static FastCalculatorBlocEvent<R> init<R extends FastCalculatorResults>() {
    return FastCalculatorBlocEvent<R>(type: FastCalculatorBlocEventType.init);
  }

  // Returns an event with the type `FastCalculatorBlocEventType.initialized`
  // and no payload.
  static FastCalculatorBlocEvent<R>
      initialized<R extends FastCalculatorResults>() {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.initialized,
    );
  }

  // Returns an event with the type `FastCalculatorBlocEventType.initFailed`
  // and a payload containing an error.
  static FastCalculatorBlocEvent<R> initFailed<R extends FastCalculatorResults>(
    dynamic error,
    dynamic stacktrace,
  ) {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.initFailed,
      payload: FastCalculatorBlocEventPayload<R>(
        stacktrace: stacktrace,
        error: error,
      ),
    );
  }

  // Returns an event with the type `FastCalculatorBlocEventType.patchValue`
  // and a payload containing a key and a value.
  static FastCalculatorBlocEvent<R>
      patchValue<R extends FastCalculatorResults>({
    required String key,
    dynamic value,
  }) {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.patchValue,
      payload: FastCalculatorBlocEventPayload<R>(key: key, value: value),
    );
  }

  static FastCalculatorBlocEvent<R>
      resetValue<R extends FastCalculatorResults>({
    required String key,
  }) {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.resetValue,
      payload: FastCalculatorBlocEventPayload<R>(key: key),
    );
  }

  // Returns an event with the type `FastCalculatorBlocEventType.compute`
  // and no payload.
  static FastCalculatorBlocEvent<R> compute<R extends FastCalculatorResults>() {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.compute,
    );
  }

  // Returns an event with the type `FastCalculatorBlocEventType.computed`
  // and a payload containing the calculator's results.
  static FastCalculatorBlocEvent<R> computed<R extends FastCalculatorResults>(
    R results,
  ) {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.computed,
      payload: FastCalculatorBlocEventPayload(results: results),
    );
  }

  // Returns an event with the type `FastCalculatorBlocEventType.computeFailed`
  // and a payload containing an error.
  static FastCalculatorBlocEvent<R>
      computeFailed<R extends FastCalculatorResults>(
    dynamic error,
  ) {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.computeFailed,
      payload: FastCalculatorBlocEventPayload(error: error),
    );
  }

  // Returns an event with the type `FastCalculatorBlocEventType.clear`
  // and no payload.
  static FastCalculatorBlocEvent<R> clear<R extends FastCalculatorResults>() {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.clear,
    );
  }

  static FastCalculatorBlocEvent<R> save<R extends FastCalculatorResults>() {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.save,
    );
  }

  // Returns an event with the type `FastCalculatorBlocEventType.custom`
  // and a payload containing a key and a value.
  static FastCalculatorBlocEvent<R> custom<R extends FastCalculatorResults>(
    String key, {
    dynamic value,
  }) {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.custom,
      payload: FastCalculatorBlocEventPayload<R>(key: key, value: value),
    );
  }

  // Returns an event with the type `FastCalculatorBlocEventType.reset`
  // and no payload.
  static FastCalculatorBlocEvent<R> reset<R extends FastCalculatorResults>() {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.reset,
    );
  }

  // Returns an event with the type `FastCalculatorBlocEventType.loadMetadata`
  // and no payload.
  static FastCalculatorBlocEvent<R>
      loadMetadata<R extends FastCalculatorResults>() {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.loadMetadata,
    );
  }

  // Returns an event with the type `FastCalculatorBlocEventType.patchMetadata`
  // and a payload containing a key and a value.
  static FastCalculatorBlocEvent<R>
      patchMetadata<R extends FastCalculatorResults>({
    required String key,
    dynamic value,
  }) {
    return FastCalculatorBlocEvent<R>(
      payload: FastCalculatorBlocEventPayload<R>(key: key, value: value),
      type: FastCalculatorBlocEventType.patchMetadata,
    );
  }

  static FastCalculatorBlocEvent<R> share<R extends FastCalculatorResults>(
    BuildContext context,
  ) {
    return FastCalculatorBlocEvent<R>(
      payload: FastCalculatorBlocEventPayload<R>(value: context),
      type: FastCalculatorBlocEventType.share,
    );
  }

  static FastCalculatorBlocEvent<R>
      exportToPdf<R extends FastCalculatorResults>(BuildContext context) {
    return FastCalculatorBlocEvent<R>(
      payload: FastCalculatorBlocEventPayload<R>(value: context),
      type: FastCalculatorBlocEventType.exportToPdf,
    );
  }

  static FastCalculatorBlocEvent<R>
      retrieveDefaultValues<R extends FastCalculatorResults>() {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.retrieveDefaultValues,
    );
  }

  static FastCalculatorBlocEvent<R>
      saveEntryChanged<R extends FastCalculatorResults>() {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.saveEntryChanged,
    );
  }
}
