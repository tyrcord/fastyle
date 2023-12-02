// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:t_helpers/helpers.dart';

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
    if (isWeb) return;

    final bloc = FastConnectivityStatusBloc.instance;
    bloc.addEvent(FastConnectivityStatusBlocEvent.init());

    final blocState = await RaceStream([
      bloc.onError,
      bloc.onData.where((state) => state.isInitialized),
    ]).first;

    if (blocState is! FastConnectivityStatusBlocState) {
      throw blocState;
    }

    if (!blocState.isConnected || !blocState.isServiceAvailable) {
      throw blocState;
    }
  }
}
