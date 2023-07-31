// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:

import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart


/// A widget that displays the app's name, author and year.
class FastAppInformation extends StatelessWidget {
  /// The custom text to display for the app copyright.
  final String? customAppCopyrightText;

  /// The custom text to display for the app version.
  final String? customAppVersionText;

  /// Whether to display a short or long copyright.
  final bool shortCopyright;

  /// The build number of the app.
  final String? buildNumber;

  /// The version of the app.
  final String? version;

  /// The author of the app.
  final String? author;

  /// The name of the app.
  final String? name;

  /// The year of the app.
  final int? year;

  const FastAppInformation({
    super.key,
    this.shortCopyright = false,
    this.customAppCopyrightText,
    this.customAppVersionText,
    this.buildNumber,
    this.version,
    this.author,
    this.name,
    this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FastAppVersion(
          customText: customAppVersionText,
          buildNumber: buildNumber,
          version: version!,
        ),
        FastAppCopyright(
          customText: customAppCopyrightText,
          short: shortCopyright,
          author: author,
          name: name,
          year: year,
        ),
        kFastSizedBox16,
      ],
    );
  }
}
