import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';
import 'package:tbloc/tbloc.dart';
import 'package:fastyle_settings/fastyle_settings.dart';

class FastSettingsPrivacyPolicyPage extends StatefulWidget {
  final List<Widget>? children;
  final double iconSize;

  const FastSettingsPrivacyPolicyPage({
    Key? key,
    this.children,
    double? iconSize,
  })  : iconSize = iconSize ?? kFastSettingIconHeight,
        super(key: key);

  @override
  FastSettingsPrivacyPolicyPageState createState() =>
      FastSettingsPrivacyPolicyPageState();
}

class FastSettingsPrivacyPolicyPageState
    extends State<FastSettingsPrivacyPolicyPage> {
  late TapGestureRecognizer _emailTapRecognizer;

  @override
  void initState() {
    super.initState();
    _emailTapRecognizer = TapGestureRecognizer();
    handleContactUs();
  }

  @override
  void dispose() {
    super.dispose();
    _emailTapRecognizer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      titleText: getPrivacyPolicyTitle(context),
      isViewScrollable: true,
      child: buildContent(),
    );
  }

  String getPrivacyPolicyTitle(BuildContext context) {
    return SettingsLocaleKeys.settings_label_privacy_policy.tr();
  }

  Widget buildContent() {
    final appInfoBloc = BlocProvider.of<FastAppInfoBloc>(context);
    final appInfo = appInfoBloc.currentState;
    final appAuthor = appInfo.appAuthor;
    final appName = appInfo.appName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildPrivacyPolicyIcon(context),
        kFastSizedBox32,
        if (appInfo.appPrivacyPolicyLastModified != null)
          FastSettingsLastModified(
            lastModifiedAt: appInfo.appPrivacyPolicyLastModified!,
          ),
        buildAppIntroductionSection(appAuthor, appName),
        buildServiceInformationSection(),
        buildInformationCollectionSection(),
        buildLogDataSection(),
        buildCookiesSection(),
        buildServiceProvidersSection(),
        buildSecuritySection(),
        buildLinksToOtherSitesSection(),
        buildChildrensPrivacySection(),
        buildChangesToPrivacyPolicySection(),
        buildContactUsSection(appInfo.supportEmail),
        ...?widget.children,
        FastAppCopyright(author: appAuthor, name: appName),
      ],
    );
  }

  Widget buildPrivacyPolicyIcon(BuildContext context) {
    final scaleFactor = MediaQuery.textScaleFactorOf(context);
    final textScaleFactor = scaleFactor > 1 ? scaleFactor : scaleFactor;
    final palette = ThemeHelper.getPaletteColors(context);

    return Center(
      child: FastRoundedDuotoneIcon(
        icon: const FaIcon(FontAwesomeIcons.userSecret),
        palette: palette.blueGray,
        size: widget.iconSize * textScaleFactor,
      ),
    );
  }

  Widget buildAppIntroductionSection(String appAuthor, String appName) {
    return FastParagraph(
      text: '$appAuthor built the $appName app as a Freemium app. This '
          'Service is provided by $appAuthor at no cost and is intended '
          'for use as is.',
    );
  }

  Widget buildServiceInformationSection() {
    return const FastParagraph(
      text: 'This page is used to inform visitors regarding our policies '
          'with the collection, use, and disclosure of Personal '
          'Information if anyone decided to use our Service.',
    );
  }

  Widget buildInformationCollectionSection() {
    return const FastParagraph(
      text: 'If you choose to use our Service, then you agree to the '
          'collection and use of information in relation to this policy. '
          'The Personal Information that we collect is used for providing '
          'and improving the Service. We will not use or share your '
          'information with anyone except as described in this Privacy Policy.',
    );
  }

  Widget buildLogDataSection() {
    return const FastArticle(
      titleText: 'Log Data',
      children: [
        FastParagraph(
          text: 'We want to inform you that whenever you use our Service, '
              'in a case of an error in the app we collect data and '
              'information (through third party products) on your phone '
              'called Log Data.',
        ),
        FastParagraph(
          text: 'This Log Data may include information such as your device '
              'Internet Protocol (“IP”) address, device name, operating '
              'system version, the configuration of the app when utilizing '
              'our Service, the time and date of your use of the Service, '
              'and other statistics.',
        ),
      ],
    );
  }

  Widget buildCookiesSection() {
    return const FastArticle(
      titleText: 'Cookies',
      children: [
        FastParagraph(
          text: 'Cookies are files with small amount of data that is '
              'commonly used an anonymous unique identifier. These are '
              'sent to your browser from the website that you visit and '
              'are stored on your device internal memory.',
        ),
        FastParagraph(
          text: 'This Service does not use these “cookies” explicitly. '
              'However, the app may use third party code and libraries '
              'that use “cookies” to collection information and to improve '
              'their services. You have the option to either accept or '
              'refuse these cookies and know when a cookie is being sent '
              'to your device. If you choose to refuse our cookies, you '
              'may not be able to use some portions of this Service.',
        ),
      ],
    );
  }

  Widget buildServiceProvidersSection() {
    return const FastArticle(
      titleText: 'Service Providers',
      children: [
        FastParagraph(
          text: 'We may employ third-party companies and individuals due '
              'to the following reasons:',
        ),
        kFastSizedBox8,
        FastBody(text: '• To facilitate our Service;'),
        FastBody(text: '• To provide the Service on our behalf;'),
        FastBody(text: '• To perform Service-related services; or'),
        FastBody(
          text: '• To assist us in analyzing how our Service is used.',
        ),
        kFastSizedBox8,
        FastParagraph(
          text: 'We want to inform users of this Service that these third '
              'parties have access to your Personal Information. The '
              'reason is to perform the tasks assigned to them on our '
              'behalf. However, they are obligated not to disclose or use '
              'the information for any other purpose.',
        ),
      ],
    );
  }

  Widget buildSecuritySection() {
    return const FastArticle(
      titleText: 'Security',
      children: [
        FastParagraph(
          text: 'We value your trust in providing us your Personal '
              'Information, thus we are striving to use commercially '
              'acceptable means of protecting it. But remember that no '
              'method of transmission over the internet, or method of '
              'electronic storage is 100% secure and reliable, and we '
              'cannot guarantee its absolute security.',
        ),
      ],
    );
  }

  Widget buildLinksToOtherSitesSection() {
    return const FastArticle(
      titleText: 'Links to Other Sites',
      children: [
        FastParagraph(
          text: 'This Service may contain links to other sites. If you '
              'click on a third-party link, you will be directed to that '
              'site. Note that these external sites are not operated by us. '
              'Therefore, we strongly advise you to review the Privacy '
              'Policy of these websites. We have no control over and assume '
              'no responsibility for the content, privacy policies, or '
              'practices of any third-party sites or services.',
        ),
      ],
    );
  }

  Widget buildChildrensPrivacySection() {
    return const FastArticle(
      titleText: 'Children’s Privacy',
      children: [
        FastParagraph(
          text: 'These Services do not address anyone under the age of '
              '13. We do not knowingly collect personally identifiable '
              'information from children under 13. In the case we discover '
              'that a child under 13 has provided us with personal '
              'information, we immediately delete this from our servers. '
              'If you are a parent or guardian and you are aware that your '
              'child has provided us with personal information, please '
              'contact us so that we will be able to do necessary actions.',
        ),
      ],
    );
  }

  Widget buildChangesToPrivacyPolicySection() {
    return const FastArticle(
      titleText: 'Changes to This Privacy Policy',
      children: [
        FastParagraph(
          text: 'We may update our Privacy Policy from time to time. '
              'Thus, you are advised to review this page periodically for '
              'any changes. We will notify you of any changes by posting '
              'the new Privacy Policy on this page. These changes are '
              'effective immediately after they are posted on this page.',
        ),
      ],
    );
  }

  Widget buildContactUsSection(String? email) {
    final palette = ThemeHelper.getPaletteColors(context);
    final bodyTextStyle = ThemeHelper.texts.getBodyTextStyle(context);
    final scaleFactor = MediaQuery.textScaleFactorOf(context);
    final spanTextStyle = bodyTextStyle.copyWith(
      fontSize: bodyTextStyle.fontSize! * scaleFactor,
    );
    final linkTextStyle = spanTextStyle.copyWith(color: palette.blue.mid);

    return FastArticle(
      titleText: 'Contact Us',
      children: [
        FastParagraph(
          child: RichText(
            text: TextSpan(
              style: spanTextStyle,
              text: 'If you have any questions or suggestions about our '
                  'Privacy Policy, do not hesitate to contact us ',
              children: [
                if (email != null)
                  TextSpan(
                    recognizer: _emailTapRecognizer,
                    style: linkTextStyle,
                    text: email,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void handleContactUs() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appInfoBloc = BlocProvider.of<FastAppInfoBloc>(context);
      final appInfo = appInfoBloc.currentState;

      _emailTapRecognizer.onTap = () {
        FastMessenger.askForSupport(appInfo.supportEmail!);
      };
    });
  }
}
