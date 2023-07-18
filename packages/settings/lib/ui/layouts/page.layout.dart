// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';

// Project imports:
import 'package:fastyle_settings/fastyle_settings.dart';

/// A layout that displays a page with a header and content.
/// It is used to display a page in a [FastSettingPage].
class FastSettingPageLayout extends StatelessWidget {
  /// The header description text of the page.
  final String? headerDescriptionText;

  /// The content padding of the page.
  final EdgeInsets? contentPadding;

  /// The actions to display in the page's app bar.
  final List<Widget>? actions;

  /// The icon to display in the page's header.
  final Widget? headerIcon;

  /// The title text of the page.
  final String? titleText;

  /// The height of the icon.
  final double iconHeight;

  /// Creates a new instance of [FastSettingPageLayout].
  const FastSettingPageLayout({
    super.key,
    this.iconHeight = kFastSettingIconHeight,
    this.headerDescriptionText,
    this.contentPadding,
    this.headerIcon,
    this.titleText,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      contentPadding: contentPadding ?? kFastVerticalEdgeInsets16,
      isViewScrollable: true,
      titleText: titleText,
      actions: actions,
      child: Column(
        children: [
          buildSettingsHeader(context),
          buildSettingsContent(context),
        ],
      ),
    );
  }

  @protected
  Widget buildSettingsHeader(BuildContext context) {
    return FastSettingPageHeaderLayout(
      icon: headerIcon ?? buildSettingsHeaderIcon(context),
      descriptionText: headerDescriptionText,
      iconHeight: iconHeight,
    );
  }

  @protected
  Widget? buildSettingsHeaderIcon(BuildContext context) {
    return null;
  }

  @protected
  Widget buildSettingsContent(BuildContext context) {
    throw UnimplementedError();
  }
}
