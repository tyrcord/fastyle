import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';
import 'package:tbloc/tbloc.dart';
import 'package:flutter/material.dart';
import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:t_helpers/helpers.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildDisclaimerIcon(context),
        kFastSizedBox32,
        if (appInfo.appDisclaimerLastModified != null)
          buildLastModifiedText(context, appInfo.appDisclaimerLastModified!),
        buildAppDisclaimerParagraph(appInfo.appName),
        buildDisclaimerParagraph(
            SettingsLocaleKeys.settings_disclaimer_data.tr()),
        if (children != null) ...children!,
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

  Widget buildLastModifiedText(BuildContext context, DateTime lastModifiedAt) {
    final appSettingsBloc = BlocProvider.of<FastAppSettingsBloc>(context);
    final appSettings = appSettingsBloc.currentState;
    final pendingDate = formatDateTime(
      lastModifiedAt,
      languageCode: appSettings.languageCode,
      countryCode: appSettings.countryCode,
      showTime: false,
    );

    return FastParagraph(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: FutureBuilder(
        future: pendingDate,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FastSecondaryBody(
              text: SettingsLocaleKeys.settings_message_last_modified
                  .tr(namedArgs: {'date': snapshot.data.toString()}),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget buildDisclaimerParagraph(String text) {
    return FastParagraph(text: text);
  }
}
