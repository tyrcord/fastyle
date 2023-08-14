// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';

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
    return FastAppSettingsLanguageBuilder(
      builder: (context, state) {
        return FastSectionPage(
          contentPadding: contentPadding,
          isViewScrollable: true,
          titleText: titleText?.tr(),
          actions: actions,
          child: Column(
            children: [
              buildSettingsHeader(context),
              buildSettingsContent(context),
            ],
          ),
        );
      },
    );
  }

  @protected
  Widget buildSettingsHeader(BuildContext context) {
    return FastSettingPageHeaderLayout(
      descriptionText: headerDescriptionText,
      icon: buildHeaderIcon(context),
      iconHeight: iconHeight,
    );
  }

  Widget? buildHeaderIcon(BuildContext context) {
    if (headerIcon != null) {
      return headerIcon!;
    }

    return buildSettingsHeaderIcon(context);
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
