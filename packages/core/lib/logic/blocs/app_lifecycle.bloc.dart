import 'dart:ui';

import 'package:tbloc/tbloc.dart';
import 'package:fastyle_core/fastyle_core.dart';

/// Singleton class to manage the app's life cycle state.
/// Utilizes the BLoC pattern for state management.
class FastAppLifecycleBloc extends BidirectionalBloc<FastAppLifecycleBlocEvent,
    FastAppLifecycleBlocState> {
  /// Flag indicating whether an instance has already been created.
  static bool _hasBeenInstantiated = false;

  /// Singleton instance of FastAppLifecycleBloc.
  static late FastAppLifecycleBloc instance;

  /// Private constructor. The underscore enforces the singleton pattern,
  /// preventing direct instantiation from other classes.
  FastAppLifecycleBloc._({FastAppLifecycleBlocState? initialState})
      : super(initialState: initialState ?? FastAppLifecycleBlocState());

  /// Factory constructor to provide a singleton instance.
  /// This ensures the class has only one instance and provides a global point
  /// of access to it.
  factory FastAppLifecycleBloc({FastAppLifecycleBlocState? initialState}) {
    if (!_hasBeenInstantiated) {
      instance = FastAppLifecycleBloc._(initialState: initialState);
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
