// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

mixin FastAdInformationJobDelegate {
  Future<FastAdInfo> onGetAdInformationModel(BuildContext context);
}

class FastAdInfoJob extends FastJob {
  static FastAdInfoJob? _singleton;

  factory FastAdInfoJob({FastAdInformationJobDelegate? delegate}) {
    return (_singleton ??= FastAdInfoJob._(delegate: delegate));
  }

  final FastAdInformationJobDelegate? delegate;

  const FastAdInfoJob._({this.delegate}) : super(debugLabel: 'FastAdInfoJob');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    if (isWeb) return;

    final adInfoBloc = FastAdInfoBloc.instance;
    FastAdInfo adInfo = adInfoBloc.currentState.adInfo;

    if (delegate != null) {
      adInfo = await delegate!.onGetAdInformationModel(context);
    }

    if (kDebugMode) {
      debugLog('will use Ad Info:', debugLabel: debugLabel);
      adInfo.debug(debugLabel: 'AdInfo');
    }

    adInfoBloc.addEvent(FastAdInfoBlocEvent.init(adInfo: adInfo));

    await adInfoBloc.onData.firstWhere((state) => state.isInitialized);

    final response = await RaceStream([
      adInfoBloc.onError,
      adInfoBloc.onData.where((FastAdInfoBlocState state) {
        return state.isInitialized;
      }),
    ]).first;

    if (response is! FastAdInfoBlocState) {
      throw response;
    }
  }
}
