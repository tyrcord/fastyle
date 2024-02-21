// Package imports:
import 'package:t_helpers/helpers.dart';

enum FastCalculatorBlocAnalyticEvent {
  computedFields,
}

extension FastCalculatorBlocAnalyticEventX on FastCalculatorBlocAnalyticEvent {
  String get snakeCase => toSnakeCase(name);
}
