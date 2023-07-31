// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_settings/fastyle_settings.dart';

class FastSettingsDisclaimerPage extends StatelessWidget {
  final List<Widget>? children;
  final double iconSize;

  const FastSettingsDisclaimerPage({
    super.key,
    this.children,
    double? iconSize,
  }) : iconSize = iconSize ?? kFastSettingIconHeight;

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      titleText: getDisclaimerTitle(context),
      isViewScrollable: true,
      child: buildContent(context),
    );
  }

  String getDisclaimerTitle(BuildContext context) {
    return SettingsLocaleKeys.settings_label_disclaimer.tr();
  }

  Widget buildContent(BuildContext context) {
    final appInfoBloc = BlocProvider.of<FastAppInfoBloc>(context);
    final appInfo = appInfoBloc.currentState;
    final appAuthor = appInfo.appAuthor;
    final appName = appInfo.appName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildDisclaimerIcon(context),
        kFastSizedBox32,
        if (appInfo.appDisclaimerLastModified != null)
          FastSettingsLastModified(
            lastModifiedAt: appInfo.appDisclaimerLastModified!,
          ),
        buildAppDisclaimerParagraph(appInfo.appName),
        buildDisclaimerParagraph(
          SettingsLocaleKeys.settings_disclaimer_data.tr(),
        ),
        ...?children,
        FastAppCopyright(author: appAuthor, name: appName),
      ],
    );
  }

  Widget buildDisclaimerIcon(BuildContext context) {
    final scaleFactor = MediaQuery.textScaleFactorOf(context);
    final textScaleFactor = scaleFactor > 1 ? scaleFactor : scaleFactor;
    final palette = ThemeHelper.getPaletteColors(context);

    return Center(
      child: FastRoundedDuotoneIcon(
        icon: const FaIcon(FontAwesomeIcons.bullhorn),
        palette: palette.blueGray,
        size: iconSize * textScaleFactor,
      ),
    );
  }

  Widget buildAppDisclaimerParagraph(String appName) {
    final disclaimerText =
        SettingsLocaleKeys.settings_disclaimer_accept_risk.tr(
      namedArgs: {'appName': appName},
    );

    return buildDisclaimerParagraph(disclaimerText);
  }

  Widget buildDisclaimerParagraph(String text) {
    return FastParagraph(text: text);
  }
}
