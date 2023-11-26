// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:tbloc/tbloc.dart';

/// Enum indicating the types of events that can be handled
/// by the [FastAppLifecycleBloc]. Currently supports a scenario
/// where the lifecycle state changes.
enum FastAppLifecycleBlocEventType {
  lifecycleChanged,
}

/// A specific type of event that captures information about changes in
/// the application's lifecycle state.
///
/// Extends [BlocEvent] to benefit from the functionalities provided
/// by the tbloc package, particularly for event handling with payload
/// pertaining to the app's lifecycle state.
class FastAppLifecycleBlocEvent
    extends BlocEvent<FastAppLifecycleBlocEventType, AppLifecycleState> {
  /// Creates a [FastAppLifecycleBlocEvent] indicating that the lifecycle
  /// state has changed.
  ///
  /// This event carries the new state within it as a payload to inform
  /// the bloc of the specific nature of the change.
  const FastAppLifecycleBlocEvent.lifecycleChanged(AppLifecycleState state)
      : super(
          type: FastAppLifecycleBlocEventType.lifecycleChanged,
          payload: state,
        );
}
