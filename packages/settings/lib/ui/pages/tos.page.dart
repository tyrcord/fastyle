// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_settings/fastyle_settings.dart';

class FastSettingsTermsOfServicePage extends StatelessWidget {
  final List<Widget>? children;
  final double iconSize;
  final Widget? icon;

  const FastSettingsTermsOfServicePage({
    super.key,
    this.children,
    this.icon,
    double? iconSize,
  }) : iconSize = iconSize ?? kFastSettingIconHeight;

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      titleText: getTermOfServiceTitle(context),
      isViewScrollable: true,
      child: buildContent(context),
    );
  }

  String getTermOfServiceTitle(BuildContext context) {
    return SettingsLocaleKeys.settings_label_terms_of_service.tr();
  }

  Widget buildContent(BuildContext context) {
    final appInfoBloc = FastAppInfoBloc.instance;
    final appInfo = appInfoBloc.currentState;
    final appName = appInfo.appName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FastPageHeaderRoundedDuotoneIconLayout(icon: buildIcon(context)),
        kFastSizedBox32,
        if (appInfo.appTermsOfServiceLastModified != null)
          FastSettingsLastModified(
            lastModifiedAt: appInfo.appTermsOfServiceLastModified!,
          ),
        buildAppTermOfServiceParagraph(appName),
        if (appInfo.supportEmail != null)
          buildAcceptingTermsArticle(appName, appInfo.supportEmail!),
        buildChangesToTermsArticle(appName),
        buildGovernLawArticle(),
        buildThirdPartyServicesArticle(),
        buildIntellectualPropertyArticle(appName),
        ...?children,
      ],
    );
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) {
      return icon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightFileContract);
    }

    return const FaIcon(FontAwesomeIcons.fileContract);
  }

  Widget buildAppTermOfServiceParagraph(String appName) {
    return buildTermOfServiceParagraph(
      'These terms of use ("Terms") apply to your access and use '
      'of $appName (the "Service"). Please read them carefully.',
    );
  }

  Widget buildAcceptingTermsArticle(String appName, String email) {
    return FastArticle(
      titleText: 'Accepting these Terms',
      children: [
        FastParagraph(
          child: FastSettingsSupportLink(
            emailText: email,
            prefixText: 'If you access or use the Service, it means you '
                'agree to be bound by all of the terms below. So, '
                'before you use the Service, please read all of the '
                'terms. If you do not agree to all of the terms below, '
                'please do not use the Service. Also, if a term does not '
                'make sense to you, please let us know by e-mailing',
          ),
        ),
      ],
    );
  }

  Widget buildChangesToTermsArticle(String appName) {
    return FastArticle(
      titleText: 'Changes to these Terms',
      children: [
        const FastParagraph(
          text: 'We reserve the right to modify these Terms at any time. '
              'For instance, we may need to change these Terms if we come '
              'out with a new feature or for some other reason.',
        ),
        buildChangesToTermsParagraph(appName),
        const FastParagraph(
          text: 'If you continue to use the Service after the revised '
              'Terms go into effect, then you have accepted the changes to '
              'these Terms.',
        ),
      ],
    );
  }

  Widget buildGovernLawArticle() {
    return const FastArticle(
      titleText: 'Governing Law',
      children: [
        FastParagraph(
          text: 'The validity of these Terms and the rights, '
              'obligations, and relations of the parties under these '
              'Terms will be construed and determined under and in '
              'accordance with the laws of France, without regard to conflicts '
              'of law principles.',
        )
      ],
    );
  }

  Widget buildThirdPartyServicesArticle() {
    return const FastArticle(
      titleText: 'Third-Party Services',
      children: [
        FastParagraph(
          text: 'From time to time, we may provide you with links to third '
              'party websites or services that we do not own or control. '
              'Your use of the Service may also include the use of '
              'applications that are developed or owned by a third party. '
              'Your use of such third party applications, websites, and '
              'services is governed by that party\'s own terms of service '
              'or privacy policies. We encourage you to read the terms and '
              'conditions and privacy policy of any third party '
              'application, website or service that you visit or use.',
        ),
      ],
    );
  }

  Widget buildIntellectualPropertyArticle(String appName) {
    return FastArticle(
      titleText: 'Intellectual Property',
      children: [
        FastParagraph(
          text: '$appName is protected by the laws of France and '
              'international intellectual property laws and you agree to '
              'abide by them. We grant you the right to use it.',
        ),
        FastParagraph(
          text: 'However, without our prior written consent, you may not '
              'download, copy or store $appName content in any form '
              'outside of $appName and you may not modify, publish, '
              'transmit, participate in the transfer or sale of, '
              'reproduce, create derivative works based on, distribute, or '
              'perform any $appName content.',
        ),
      ],
    );
  }

  Widget buildChangesToTermsParagraph(String appName) {
    return FastParagraph(
      text: 'Whenever we make changes to these Terms, the changes are '
          'effective immediately after we post such revised Terms '
          '(indicated by revising the date at the top of these Terms) upon '
          'your acceptance if we provide a mechanism for your immediate or '
          'acceptance of the revised Terms (such as a click-through '
          'confirmation or acceptance button). It is your responsibility to '
          'check $appName for changes to these Terms.',
    );
  }

  Widget buildTermOfServiceParagraph(String text) => FastParagraph(text: text);
}
