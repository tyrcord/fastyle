// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

/// A widget that displays the app's name, author and year.
class FastAppCopyright extends StatelessWidget {
  /// The margin of the widget.
  final EdgeInsets? margin;

  /// The custom text to display.
  final String? customText;

  /// The author of the app.
  final String? author;

  /// The name of the app.
  final String? name;

  /// Whether to display a short or long copyright.
  final bool short;

  /// The year of the app.
  final int? year;

  const FastAppCopyright({
    super.key,
    this.short = false,
    this.customText,
    this.margin,
    this.author,
    this.year,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return FastParagraph(
      margin: margin ?? const EdgeInsets.only(top: 16.0),
      child: FastSecondaryBody(
        textAlign: TextAlign.center,
        text: _getCopyright(),
      ),
    );
  }

  /// Returns the copyright text.
  String _getCopyright() {
    if (customText != null && customText!.isNotEmpty) {
      return customText!;
    }

    return short ? _getShortCopyright() : _getLongCopyright();
  }

  /// Returns the short copyright text.
  String _getShortCopyright() {
    return '${_getName()}Copyright ${_getYear()}${_getAuthor()}.';
  }

  /// Returns the long copyright text.
  String _getLongCopyright() {
    return '${_getShortCopyright()} All rights reserved.';
  }

  /// Returns the year.
  String _getYear() {
    final year0 = year ?? DateTime.now().year;

    return year0.toString();
  }

  /// Returns the author
  String _getAuthor() {
    return author != null ? ' $author' : '';
  }

  /// Returns the name.
  String _getName() {
    return name != null ? '$name ' : '';
  }
}
