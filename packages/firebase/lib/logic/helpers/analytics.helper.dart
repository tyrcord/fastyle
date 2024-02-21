import 'package:fastyle_core/fastyle_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:tbloc/tbloc.dart';

void logFastBlocAnalyticsEvent(BlocAnalyticsEvent event) {
  final analytics = FirebaseAnalytics.instance;
  final parameters = event.parameters;
  final type = event.type;

  // Log the export results analytics event.
  if (type is FastBlocAnalyticsEvent) {
    final eventName = type.snakeCase;
    analytics.logEvent(name: eventName, parameters: parameters);
  }
}
