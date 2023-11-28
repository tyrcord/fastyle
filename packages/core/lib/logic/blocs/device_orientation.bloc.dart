// Package imports:
import 'package:flutter/material.dart';
import 'package:tbloc/tbloc.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastDeviceOrientationBloc extends BidirectionalBloc<
    FastDeviceOrientationBlocEvent, FastDeviceOrientationBlocState> {
  static bool _hasBeenInstantiated = false;
  static late FastDeviceOrientationBloc instance;
  static late final TLogger _logger;

  FastDeviceOrientationBloc._({FastDeviceOrientationBlocState? initialState})
      : super(initialState: initialState ?? FastDeviceOrientationBlocState());

  factory FastDeviceOrientationBloc({
    FastDeviceOrientationBlocState? initialState,
  }) {
    if (!_hasBeenInstantiated) {
      final manager = TLoggerManager();
      _logger = manager.getLogger('FastDeviceOrientationListener');
      instance = FastDeviceOrientationBloc._(initialState: initialState);

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
