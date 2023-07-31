// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_core/fastyle_core.dart';

class AdmobRewardedAdsPage extends StatefulWidget {
  const AdmobRewardedAdsPage({super.key});

  @override
  State<AdmobRewardedAdsPage> createState() => AdmobRewardedAdsPageState();
}

class AdmobRewardedAdsPageState extends State<AdmobRewardedAdsPage> {
  final rewardedAdBloc = FastRewardedAdBloc();
  final adBloc = FastAdInfoBloc();

  @override
  void dispose() {
    super.dispose();
    _cancelAdRequest();
  }

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      titleText: 'Rewarded Ads',
      isViewScrollable: true,
      child: Column(
        children: [
          FastRewardedAdBuilder(
            builder: (context, state) {
              Widget? content;

              if (state.hasError) {
                content = const FastTitle(text: 'No ad to show');
              } else if (state.isLoadingAd) {
                content = const FastThreeBounceIndicator();
              } else if (state.isRewarded) {
                content = const FastTitle(text: 'Ad rewarded');
              } else if (state.hasDismissedAd) {
                content = const FastTitle(text: 'Ad dismissed');
              } else {
                content = const FastTitle(text: 'No ad loaded');
              }

              return SizedBox(
                height: 128,
                child: Center(child: content),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FastOutlineButton(text: 'reset', onTap: _cancelAdRequest),
              FastRewardedAdBuilder(builder: (context, state) {
                return FastRaisedButton(
                  text: 'Show rewarded ad',
                  isEnabled: !state.isLoadingAd,
                  onTap: () {
                    rewardedAdBloc.addEvent(
                      const FastRewardedAdBlocEvent.loadAndShowAd(),
                    );
                  },
                );
              }),
            ],
          )
        ],
      ),
    );
  }

  void _cancelAdRequest() {
    rewardedAdBloc.addEvent(const FastRewardedAdBlocEvent.cancelAdRequest());
  }
}
