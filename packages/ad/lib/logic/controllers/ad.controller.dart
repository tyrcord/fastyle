// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

abstract class FastAdController {
  @protected
  final eventController = PublishSubject<FastAdRequestEvent>();

  Stream get onEvent => eventController.stream;

  dynamic listen();

  Future<dynamic> close() {
    return eventController.close();
  }

  @protected
  void onAdLoaded(Ad ad) {
    eventController.sink.add(FastAdRequestEvent.loaded);
  }

  @protected
  void onAdFailedToLoad(Ad ad, LoadAdError error) {
    ad.dispose();
    eventController.sink.add(FastAdRequestEvent.failed);
  }
}
