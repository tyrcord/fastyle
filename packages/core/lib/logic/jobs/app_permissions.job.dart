// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppPermissionsJob extends FastJob {
  static FastAppPermissionsJob? _singleton;

  factory FastAppPermissionsJob() {
    return (_singleton ??= const FastAppPermissionsJob._());
  }

  const FastAppPermissionsJob._() : super(debugLabel: 'FastAppPermissionsJob');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final bloc = BlocProvider.of<FastAppPermissionsBloc>(context);
    bloc.addEvent(const FastAppPermissionsBlocEvent.init());

    final blocState = await RaceStream([
      bloc.onData.where((state) => state.isInitialized),
      bloc.onError,
    ]).first;

    if (blocState is! FastAppPermissionsBlocState) {
      throw blocState;
    }
  }
}
