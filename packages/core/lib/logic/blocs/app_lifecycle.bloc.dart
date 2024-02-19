// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// Singleton class to manage the app's life cycle state.
/// Utilizes the BLoC pattern for state management.
class FastAppLifecycleBloc extends BidirectionalBloc<FastAppLifecycleBlocEvent,
    FastAppLifecycleBlocState> {
  /// Keeps track if a singleton instance has been created.
  static bool get hasBeenInstantiated => _hasBeenInstantiated;
  static bool _hasBeenInstantiated = false;

  static final _logger = TLoggerManager.instance.getLogger(debugLabel);
  static const debugLabel = 'FastAppLifecycleBloc';

  /// Singleton instance of FastAppLifecycleBloc.
  static late FastAppLifecycleBloc _instance;

  static FastAppLifecycleBloc get instance {
    if (!_hasBeenInstantiated) return FastAppLifecycleBloc();

    return _instance;
  }

  // Method to reset the singleton instance
  static void reset() => _instance.resetBloc();

  /// Private constructor. The underscore enforces the singleton pattern,
  /// preventing direct instantiation from other classes.
  FastAppLifecycleBloc._() : super(initialState: FastAppLifecycleBlocState());

  /// Factory constructor to provide a singleton instance.
  /// This ensures the class has only one instance and provides a global point
  /// of access to it.
  factory FastAppLifecycleBloc() {
    if (!_hasBeenInstantiated) {
      _instance = FastAppLifecycleBloc._();
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  /// Overriding canClose to prevent the bloc from being inadvertently closed.
  @override
  bool canClose() => false;

  /// Main function to map incoming events to state changes.
  /// This function reacts to incoming life cycle events and updates the state
  /// accordingly.
  @override
  Stream<FastAppLifecycleBlocState> mapEventToState(
    FastAppLifecycleBlocEvent event,
  ) async* {
    final payload = event.payload;
    final type = event.type;

    _logger.debug('Event received: $type');

    if (type == FastAppLifecycleBlocEventType.lifecycleChanged) {
      yield* _handleLifecycleChanged(payload);
    }
  }

  /// Function to handle lifecycle change events.
  Stream<FastAppLifecycleBlocState> _handleLifecycleChanged(
    AppLifecycleState? state,
  ) async* {
    yield currentState.copyWith(appLifeCycleState: state);
  }
}
