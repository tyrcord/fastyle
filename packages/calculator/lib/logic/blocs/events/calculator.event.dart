import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:tbloc/tbloc.dart';

class FastCalculatorBlocEvent<R extends FastCalculatorResults>
    extends BlocEvent<FastCalculatorBlocEventType,
        FastCalculatorBlocEventPayload<R>> {
  const FastCalculatorBlocEvent({
    required FastCalculatorBlocEventType type,
    FastCalculatorBlocEventPayload<R>? payload,
  }) : super(type: type, payload: payload);

  static FastCalculatorBlocEvent<R> init<R extends FastCalculatorResults>() {
    return FastCalculatorBlocEvent<R>(type: FastCalculatorBlocEventType.init);
  }

  static FastCalculatorBlocEvent<R>
      initialized<R extends FastCalculatorResults>() {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.initialized,
    );
  }

  static FastCalculatorBlocEvent<R> initFailed<R extends FastCalculatorResults>(
    dynamic error,
  ) {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.initFailed,
      payload: FastCalculatorBlocEventPayload<R>(error: error),
    );
  }

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

  static FastCalculatorBlocEvent<R> compute<R extends FastCalculatorResults>() {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.compute,
    );
  }

  static FastCalculatorBlocEvent<R> computed<R extends FastCalculatorResults>(
    R results,
  ) {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.computed,
      payload: FastCalculatorBlocEventPayload(results: results),
    );
  }

  static FastCalculatorBlocEvent<R>
      computeFailed<R extends FastCalculatorResults>(
    dynamic error,
  ) {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.computeFailed,
      payload: FastCalculatorBlocEventPayload(error: error),
    );
  }

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

  static FastCalculatorBlocEvent<R> custom<R extends FastCalculatorResults>(
    String key, {
    dynamic value,
  }) {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.custom,
      payload: FastCalculatorBlocEventPayload(key: key, value: value),
    );
  }

  static FastCalculatorBlocEvent<R> reset<R extends FastCalculatorResults>() {
    return FastCalculatorBlocEvent<R>(
      type: FastCalculatorBlocEventType.reset,
    );
  }
}
