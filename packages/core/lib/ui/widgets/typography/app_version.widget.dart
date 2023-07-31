// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

/// A widget that displays the app's version.
class FastAppVersion extends StatelessWidget {
  /// The build number of the app.
  final String? buildNumber;

  /// The custom text to display.
  final String? customText;

  /// The margin of the widget.
  final EdgeInsets? margin;

  /// The version of the app.
  final String version;

  const FastAppVersion({
    super.key,
    required this.version,
    this.buildNumber,
    this.customText,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return FastParagraph(
      margin: margin ?? const EdgeInsets.only(top: 16.0),
      child: FastSecondaryBody(
        textAlign: TextAlign.center,
        text: _getVersionText(),
      ),
    );
  }

  /// Returns the version text.
  String _getVersionText() {
    return customText ?? 'Version $version ${_getBuildNumber()}';
  }

  /// Returns the build number.
  String _getBuildNumber() {
    if (buildNumber != null && buildNumber!.isNotEmpty) {
      return '($buildNumber)';
    }

    return '';
  }
}
