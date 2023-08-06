// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

// TODO: support more native ad heights
class FastSmartNativeAd extends StatefulWidget {
  final WidgetBuilder? fallbackBuilder;
  final Duration refreshTimeout;
  final Widget? loadingWidget;
  final String? debugLabel;
  final FastAdInfo? adInfo;
  final FastAdSize adSize;
  final String? country;
  final String? language;
  final FastAdSlotDelegate? delegate;
  final Widget? placeholder;
  final String? adId;

  const FastSmartNativeAd({
    super.key,
    this.adSize = FastAdSize.medium,
    this.fallbackBuilder,
    this.debugLabel,
    this.country,
    this.adInfo,
    this.loadingWidget,
    this.language,
    this.placeholder,
    this.delegate,
    this.adId,
    Duration? refreshTimeout,
  })  : refreshTimeout = refreshTimeout ?? kFastRefreshTimeout,
        assert(
          adSize == FastAdSize.medium,
          'Only support native ad with a height of 120px',
        );

  @override
  FastSmartNativeAdState createState() => FastSmartNativeAdState();
}

class FastSmartNativeAdState extends State<FastSmartNativeAd> {
  FastNativeAdBloc? _nativeAdBloc;
  Timer? _refreshTimer;
  NativeAd? _adView;

  @override
  void initState() {
    super.initState();

    final (language, country) = _getUserInfo();
    final payload = FastNativeAdBlocEventPayload(
      country: country,
      language: language,
      adInfo: _getAdInfo(),
      adId: widget.adId,
    );

    _nativeAdBloc = FastNativeAdBloc();
    _nativeAdBloc?.addEvent(FastNativeAdBlocEvent.init(payload));

    _loadAd(payload);

    _refreshTimer = Timer.periodic(widget.refreshTimeout, (Timer timer) {
      _loadAd(payload);
    });
  }

  @override
  void dispose() {
    super.dispose();

    _nativeAdBloc?.close();
    _refreshTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final canShowAd = widget.delegate?.willShowAd() ?? true;

    if (!canShowAd) {
      return widget.placeholder ?? const SizedBox.shrink();
    }

    if (_nativeAdBloc == null && _adView != null) {
      return buildAdmobNativeAd(_adView!, widget.adSize);
    }

    return FastNativeAdBuilder(
      bloc: _nativeAdBloc!,
      builder: (BuildContext context, FastNativeAdBlocState state) {
        if (state.adView != null) {
          return buildAdmobNativeAd(state.adView as NativeAd, widget.adSize);
        } else if (state.ad != null) {
          return FastNativeAd(ad: state.ad!, adSize: widget.adSize);
        } else if (state.showFallback) {
          return buildFallback(context);
        }

        return widget.loadingWidget ?? getLoadingWidget(widget.adSize);
      },
    );
  }

  Widget buildFallback(BuildContext context) {
    if (widget.fallbackBuilder != null) {
      return widget.fallbackBuilder!(context);
    }

    return buildDefaultNativeAd();
  }

  Widget buildDefaultNativeAd() {
    return FastDefaultNativeAd(adSize: widget.adSize);
  }

  Widget buildAdmobNativeAd(NativeAd adView, FastAdSize adSize) {
    return FastNativeAdContainerLayout(
      adSize: adSize,
      child: AdWidget(ad: adView),
    );
  }

  Future<void> _loadAd(FastNativeAdBlocEventPayload payload) async {
    if (mounted) {
      await _nativeAdBloc!.onData.where((state) => state.isInitialized).first;
      debugLog(
        'FastNativeAdBloc is loading an ad...',
        debugLabel: widget.debugLabel,
      );

      _nativeAdBloc!.addEvent(FastNativeAdBlocEvent.loadAd(payload));
    }
  }

  FastAdInfo _getAdInfo() {
    if (widget.adInfo != null) {
      return widget.adInfo!;
    }

    final adInfoBloc = FastAdInfoBloc();

    return adInfoBloc.currentState.adInfo;
  }

  (String, String?) _getUserInfo() {
    final appInfoBloc = FastAppInfoBloc();
    final appSettingsBloc = FastAppSettingsBloc();
    final appInfo = appInfoBloc.currentState;
    final appSettings = appSettingsBloc.currentState;
    final country = widget.country ?? appInfo.deviceCountryCode;
    final language = widget.language ?? appSettings.languageCode;

    return (language, country);
  }
}
