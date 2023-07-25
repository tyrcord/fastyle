library fastyle_ad;

import 'package:flutter/services.dart';

export 'logic/logic.dart';
export 'ui/ui.dart';

class FastAd {
  static const MethodChannel _channel = MethodChannel('fastyle_ad');

  static Future<dynamic> initialize() {
    return _channel.invokeMethod<void>('initialize');
  }
}
