// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppConnectivityJob extends FastJob {
  static FastAppConnectivityJob? _singleton;

  factory FastAppConnectivityJob() {
    return (_singleton ??= const FastAppConnectivityJob._());
  }

  const FastAppConnectivityJob._()
      : super(debugLabel: 'FastAppConnectivityJob');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final bloc = FastConnectivityStatusBloc.instance;
    bloc.addEvent(FastConnectivityStatusBlocEvent.init());

    final blocState = await RaceStream([
      bloc.onError,
      bloc.onData.where((state) => state.isInitialized),
    ]).first;

    if (blocState is! FastConnectivityStatusBlocState ||
        !blocState.hasConnection) {
      throw blocState;
    }
  }
}
