// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_firebase/fastyle_firebase.dart';

Map<String, dynamic>? parseDefaultConfig(String text) {
  try {
    return jsonDecode(text) as Map<String, dynamic>?;
  } catch (e) {
    return {};
  }
}

class FastFirebaseRemoteConfigJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastFirebaseRemoteConfigJob';
  static const _defaultConfigPath = 'assets/config/defaults.json';
  static FastFirebaseRemoteConfigJob? _singleton;
  static final _manager = TLoggerManager();

  final Map<String, dynamic>? defaultConfig;
  late final String defaultConfigPath;

  factory FastFirebaseRemoteConfigJob({
    Map<String, dynamic>? defaultConfig,
    String? defaultConfigPath,
  }) {
    _singleton ??= FastFirebaseRemoteConfigJob._(
      configPath: defaultConfigPath,
      defaultConfig: defaultConfig,
    );

    return _singleton!;
  }

  FastFirebaseRemoteConfigJob._({
    this.defaultConfig,
    String? configPath,
  }) : super(debugLabel: _debugLabel) {
    defaultConfigPath = configPath ?? _defaultConfigPath;
  }

  Future<String?> _loadDefaultConfig(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    _logger.debug('Initializing...');

    final bloc = FastFirebaseRemoteConfigBloc.instance;
    var customConfig = defaultConfig;

    if (customConfig == null) {
      _logger.debug('Loading default config...');

      final defaultConfigData = await _loadDefaultConfig(defaultConfigPath);

      if (defaultConfigData != null) {
        _logger.debug('Parsing default config...');
        customConfig = await compute(parseDefaultConfig, defaultConfigData);
      }
    }

    _logger.debug('Loaded default config: $customConfig');

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
