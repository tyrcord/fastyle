// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

// Package imports:



class FastAppInfoJob extends FastJob {
  static FastAppInfoJob? _singleton;

  final DatabaseVersionChanged? onDatabaseVersionChanged;
  final FastAppInfoDocument appInfoDocument;

  factory FastAppInfoJob(
    FastAppInfoDocument appInformationModel, {
    DatabaseVersionChanged? onDatabaseVersionChanged,
  }) {
    return (_singleton ??= FastAppInfoJob._(
      appInformationModel,
      onDatabaseVersionChanged: onDatabaseVersionChanged,
    ));
  }

  const FastAppInfoJob._(
    this.appInfoDocument, {
    this.onDatabaseVersionChanged,
  }) : super(debugLabel: 'fast_app_info_job');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final bloc = BlocProvider.of<FastAppInfoBloc>(context);
    bloc.addEvent(FastAppInfoBlocEvent.init(appInfoDocument));

    final appInfoState = await RaceStream([
      bloc.onError,
      bloc.onData.where((FastAppInfoBlocState state) => state.isInitialized),
    ]).first;

    if (appInfoState is! FastAppInfoBlocState) {
      throw appInfoState;
    }

    final nextVersion = appInfoDocument.databaseVersion;
    final previousVersion = appInfoState.previousDatabaseVersion;
    final hasDatabaseVersionChanged = nextVersion != previousVersion;

    if (hasDatabaseVersionChanged && onDatabaseVersionChanged != null) {
      // FIXME: should be called at the end of the initialization process
      return onDatabaseVersionChanged!(previousVersion, nextVersion);
    }
  }
}
