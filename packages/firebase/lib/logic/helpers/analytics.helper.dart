import 'package:fastyle_core/fastyle_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';

void logAnalyticsEvent({
  required String name,
  Map<String, dynamic>? parameters,
}) {
  final analytics = FirebaseAnalytics.instance;
  final sanitizedParams = _sanitizeAnalyticsParams(parameters);

  try {
    analytics.logEvent(name: name, parameters: sanitizedParams);
  } catch (e) {
    debugLog(
      'Failed to log analytics event: $name',
      value: e,
    );
  }
}

void logFastBlocAnalyticsEvent(BlocAnalyticsEvent event) {
  final parameters = event.parameters;
  final type = event.type;

  if (type is FastBlocAnalyticsEvent) {
    logAnalyticsEvent(name: type.snakeCase, parameters: parameters);
  }
}

Map<String, dynamic>? _sanitizeAnalyticsParams(
  Map<String, dynamic>? originalMap,
) {
  if (originalMap == null) return null;

  return Map<String, dynamic>.fromEntries(
    originalMap.entries.where((entry) {
      final keyLength = entry.key.length;

      if (keyLength > 40) {
        debugLog('The key "${entry.key}" is too long and will be discarded.');

        return false;
      }

      return entry.value != null && entry.value != '';
    }).map((entry) {
      var value = entry.value;

      if (value is! String && value is! num) {
        value = value.toString();
      }

      return MapEntry<String, dynamic>(entry.key, value);
    }),
  );
}
