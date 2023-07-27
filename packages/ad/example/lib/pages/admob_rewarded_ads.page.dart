import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';

class AdmobRewardedAdsPage extends StatefulWidget {
  const AdmobRewardedAdsPage({super.key});

  @override
  State<AdmobRewardedAdsPage> createState() => AdmobRewardedAdsPageState();
}

class AdmobRewardedAdsPageState extends State<AdmobRewardedAdsPage> {
  final rewardedAdBloc = FastRewardedAdBloc();
  final adBloc = FastAdInfoBloc();

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      titleText: 'Rewarded Ads',
      isViewScrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FastRaisedButton(
            text: 'Show rewarded ad',
            onTap: () async {
              rewardedAdBloc.addEvent(
                const FastRewardedAdBlocEvent.loadAndShowAd(),
              );
            },
          ),
        ],
      ),
    );
  }
}
