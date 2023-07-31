// Package imports:
import 'package:diacritic/diacritic.dart';

//@FIXME: move it to t_helpers

///
/// Removes any diacritics from text and lowercase it.
///
String normalizeTextByRemovingDiacritics(String text) {
  return removeDiacritics(text.toLowerCase());
}
