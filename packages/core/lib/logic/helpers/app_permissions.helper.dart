// Package imports:
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

FastAppPermission getTrackingPermission(TrackingStatus status) {
  if (status == TrackingStatus.authorized ||
      status == TrackingStatus.notSupported) {
    // The user authorizes access to tracking or the platform is not
    // iOS or the iOS version is below 14.0

    return FastAppPermission.granted;
  } else if (status == TrackingStatus.restricted) {
    return FastAppPermission.restricted;
  } else if (status == TrackingStatus.denied) {
    return FastAppPermission.denied;
  }

  return FastAppPermission.unknown;
}
