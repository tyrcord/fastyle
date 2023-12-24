// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_firebase/fastyle_firebase.dart';

class FastFirebaseRemoteConfigJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastFirebaseRemoteConfigJob';
  static FastFirebaseRemoteConfigJob? _singleton;
  static final _manager = TLoggerManager();

  final Map<String, dynamic>? defaultConfig;

  factory FastFirebaseRemoteConfigJob({
    Map<String, dynamic>? defaultConfig,
  }) {
    _singleton ??= FastFirebaseRemoteConfigJob._(defaultConfig: defaultConfig);

    return _singleton!;
  }

  const FastFirebaseRemoteConfigJob._({this.defaultConfig})
      : super(debugLabel: _debugLabel);

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    _logger.debug('Initializing...');

    final bloc = FastFirebaseRemoteConfigBloc.instance;
    bloc.addEvent(FastFirebaseRemoteConfigBlocEvent.init(
      defaultConfig: defaultConfig,
    ));

    final response = await RaceStream([
      bloc.onError,
      bloc.onData.where((FastFirebaseRemoteConfigBlocState state) {
        return state.isInitialized;
      }),
    ]).first;

    if (response is! FastFirebaseRemoteConfigBlocState) {
      _logger.error('Failed to initialize: $response');
      throw response;
    }

    _logger.debug('Initialized');
  }
}
