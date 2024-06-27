import 'package:flutter/widgets.dart';

class FastAction {
  final String Function(BuildContext) textGetter;
  final Function(BuildContext) action;

  FastAction({
    required this.action,
    required this.textGetter,
  });
}
