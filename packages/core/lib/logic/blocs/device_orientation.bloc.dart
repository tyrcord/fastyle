// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastDeviceOrientationBloc extends BidirectionalBloc<
    FastDeviceOrientationBlocEvent, FastDeviceOrientationBlocState> {
  /// Keeps track if a singleton instance has been created.
  static bool get hasBeenInstantiated => _hasBeenInstantiated;
  static bool _hasBeenInstantiated = false;

  static final _logger = TLoggerManager.instance.getLogger(debugLabel);
  static const debugLabel = 'FastDeviceOrientationBloc';

  static late FastDeviceOrientationBloc _instance;

  static FastDeviceOrientationBloc get instance {
    if (!_hasBeenInstantiated) return FastDeviceOrientationBloc();

    return _instance;
  }

  // Method to reset the singleton instance
  static void reset() => _instance.resetBloc();

  FastDeviceOrientationBloc._()
      : super(initialState: FastDeviceOrientationBlocState());

  factory FastDeviceOrientationBloc() {
    if (!_hasBeenInstantiated) {
      _instance = FastDeviceOrientationBloc._();
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  @override
  bool canClose() => false;

  @override
  Stream<FastDeviceOrientationBlocState> mapEventToState(
    FastDeviceOrientationBlocEvent event,
  ) async* {
    if (event.type == FastDeviceOrientationBlocEventType.changed) {
      final orientation = event.payload as Orientation;

      if (orientation != currentState.orientation) {
        _logger.debug('Device orientation changed to ${orientation.name}');

        yield currentState.copyWith(orientation: orientation);
      }
    }
  }
}
