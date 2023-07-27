// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastRewardedAdBlocEvent extends BlocEvent<
    FastAdmobRewardedAdBlocEventType, FastRewardedAdBlocEventPayload> {
  const FastRewardedAdBlocEvent.init(
    FastRewardedAdBlocEventPayload payload,
  ) : super(type: FastAdmobRewardedAdBlocEventType.init, payload: payload);

  const FastRewardedAdBlocEvent.initialized()
      : super(type: FastAdmobRewardedAdBlocEventType.initalized);

  const FastRewardedAdBlocEvent.loadAndShowAd()
      : super(type: FastAdmobRewardedAdBlocEventType.loadAndShowAd);

  const FastRewardedAdBlocEvent.adLoaded()
      : super(type: FastAdmobRewardedAdBlocEventType.adLoaded);

  FastRewardedAdBlocEvent.adLoadingError(dynamic error)
      : super(
          type: FastAdmobRewardedAdBlocEventType.adLoadingError,
          payload: FastRewardedAdBlocEventPayload(error: error),
        );

  FastRewardedAdBlocEvent.adShowingError(dynamic error)
      : super(
          type: FastAdmobRewardedAdBlocEventType.adShowingError,
          payload: FastRewardedAdBlocEventPayload(error: error),
        );

  const FastRewardedAdBlocEvent.adShowed()
      : super(type: FastAdmobRewardedAdBlocEventType.adShowed);

  FastRewardedAdBlocEvent.earnedReward(RewardItem reward)
      : super(
          type: FastAdmobRewardedAdBlocEventType.earnedReward,
          payload: FastRewardedAdBlocEventPayload(reward: reward),
        );

  const FastRewardedAdBlocEvent.adDismissed()
      : super(type: FastAdmobRewardedAdBlocEventType.adDismissed);

  const FastRewardedAdBlocEvent.cancelAdRequest()
      : super(type: FastAdmobRewardedAdBlocEventType.cancelAdRequest);
}
