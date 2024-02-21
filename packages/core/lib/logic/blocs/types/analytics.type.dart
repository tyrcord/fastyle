// Package imports:
import 'package:t_helpers/helpers.dart';

enum FastBlocAnalyticsEvent {
  appSettingEntry,
  appDictEntry,
}

extension FastBlocAnalyticsEventX on FastBlocAnalyticsEvent {
  String get snakeCase => toSnakeCase(name);
}
