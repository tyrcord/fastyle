// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_firebase/fastyle_firebase.dart';

class FastFirebaseRemoteConfigJob extends FastJob {
  static FastFirebaseRemoteConfigJob? _singleton;

  final Map<String, dynamic>? defaultConfig;

  factory FastFirebaseRemoteConfigJob({
    Map<String, dynamic>? defaultConfig,
  }) {
    _singleton ??= FastFirebaseRemoteConfigJob._(defaultConfig: defaultConfig);

    return _singleton!;
  }

  const FastFirebaseRemoteConfigJob._({this.defaultConfig})
      : super(debugLabel: 'FastFirebaseRemoteConfigJob');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final bloc = BlocProvider.of<FastFirebaseRemoteConfigBloc>(context);
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
      throw response;
    }
  }
}
