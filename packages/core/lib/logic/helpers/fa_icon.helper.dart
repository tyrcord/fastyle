// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

extension FastFaIconExtension on FaIcon {
  /// The [FaIconData] of this icon, to build a copy of it with new styles.
  FaIconData? get faIconData {
    final data = icon;

    return data == null ? null : FaIconData(data);
  }
}
