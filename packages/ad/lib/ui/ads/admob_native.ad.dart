import 'package:fastyle_core/fastyle_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

import 'package:fastyle_ad/fastyle_ad.dart';

// TODO: support more native ad heights
class FastAdmobNativeAd extends StatefulWidget {
  final FastAdSize adSize;
  final NativeAd? adView;
  final FastAdInfo? adInfo;
  final String? country;
  final WidgetBuilder? fallbackBuilder;

  const FastAdmobNativeAd({
    super.key,
    this.adView,
    this.adInfo,
    this.country,
    this.adSize = FastAdSize.medium,
    this.fallbackBuilder,
  }) : assert(
          adSize == FastAdSize.medium,
          'Only support native ad with a height of 120px',
        );

  @override
  FastAdmobNativeAdState createState() => FastAdmobNativeAdState();
}

class FastAdmobNativeAdState extends State<FastAdmobNativeAd> {
  NativeAd? _adView;
  FastNativeAdBloc? _nativeAdBloc;

  @override
  void initState() {
    super.initState();

    if (widget.adView != null) {
      _adView = widget.adView!;
      _adView!.load();
    } else {
      final payload = FastNativeAdBlocEventPayload(
        country: _getUserCountry(),
        adInfo: _getAdInfo(),
      );

      _nativeAdBloc = FastNativeAdBloc();
      _nativeAdBloc?.addEvent(FastNativeAdBlocEvent.init(payload));

      _loadAd(payload);
    }
  }

  @override
  void dispose() {
    super.dispose();

    if (widget.adView != null) {
      _adView!.dispose();
    } else {
      _nativeAdBloc?.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_nativeAdBloc == null && _adView != null) {
      return buildNativeAd(_adView!, widget.adSize);
    }

    return FastNativeAdBuilder(
      bloc: _nativeAdBloc!,
      builder: (BuildContext context, FastNativeAdBlocState state) {
        if (state.adView != null) {
          return buildNativeAd(state.adView as NativeAd, widget.adSize);
        } else if (state.showFallback) {
          return widget.fallbackBuilder?.call(context) ??
              const FastDefaultNativeAd();
        }

        return FastNativeAdLayout(
          adSize: widget.adSize,
          loading: true,
        );
      },
    );
  }

  Widget buildNativeAd(NativeAd adView, FastAdSize adSize) {
    return FastNativeAdContainerLayout(
      adSize: adSize,
      child: AdWidget(ad: adView),
    );
  }

  FastAdInfo _getAdInfo() {
    if (widget.adInfo != null) {
      return widget.adInfo!;
    }

    final adInfoBloc = FastAdInfoBloc();

    return adInfoBloc.currentState.adInfo;
  }

  String? _getUserCountry() {
    if (widget.country != null) {
      return widget.country!;
    }

    final adInfoBloc = FastAppInfoBloc();

    return adInfoBloc.currentState.deviceCountryCode;
  }

  void _loadAd(FastNativeAdBlocEventPayload payload) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _nativeAdBloc!.onData.where((state) => state.isInitialized).first;
        debugPrint('FastNativeAdBloc is loading an ad...');

        _nativeAdBloc!.addEvent(FastNativeAdBlocEvent.loadAd(payload));
      }
    });
  }
}
