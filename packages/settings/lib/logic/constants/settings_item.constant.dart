import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';
import 'package:lingua_calculator/generated/locale_keys.g.dart';

const kFastSettingsItemDescriptors = {
  FastSettingsItems.twitter: FastItem(
    labelText: 'Twitter',
    value: 'action://twitter',
  ),
  FastSettingsItems.facebook: FastItem(
    labelText: 'Facebook',
    value: 'action://facebook',
  ),
  FastSettingsItems.website: FastItem(
    labelText: CoreLocaleKeys.core_label_website,
    value: 'action://site',
  ),
  FastSettingsItems.share: FastItem(
    labelText: CoreLocaleKeys.core_label_share_app,
    value: 'action://share',
  ),
  FastSettingsItems.rateUs: FastItem(
    labelText: SettingsLocaleKeys.settings_label_rate_us,
    value: 'action://rate-us',
  ),
  FastSettingsItems.contactUs: FastItem(
    labelText: SettingsLocaleKeys.settings_label_help_and_support,
    value: 'action://contact-us',
  ),
  FastSettingsItems.bugReport: FastItem(
    labelText: SettingsLocaleKeys.settings_label_submit_bug_report,
    value: 'action://bug-report',
  ),
  FastSettingsItems.privacyPolicy: FastItem(
    labelText: SettingsLocaleKeys.settings_label_privacy_policy,
    value: 'privacy-policy',
  ),
  FastSettingsItems.termsOfService: FastItem(
    labelText: SettingsLocaleKeys.settings_label_terms_of_service,
    value: 'terms-of-service',
  ),
  FastSettingsItems.disclaimer: FastItem(
    labelText: SettingsLocaleKeys.settings_label_disclaimer,
    value: 'disclaimer',
  ),
  FastSettingsItems.appearance: FastItem(
    labelText: SettingsLocaleKeys.settings_label_appearance,
    value: 'appearance',
  ),
  FastSettingsItems.language: FastItem(
    labelText: SettingsLocaleKeys.settings_label_languages,
    value: 'language',
  ),
  FastSettingsItems.calculator: FastItem(
    labelText: CalculatorLocaleKeys.calculator_label_calculator,
    value: 'calculator',
  ),
};

const kFastSettingsItemIcons = {
  FastSettingsItems.twitter: FastSettingsItemIcon(
    pro: FastFontAwesomeIcons.twitter,
    free: FontAwesomeIcons.twitter,
  ),
  FastSettingsItems.facebook: FastSettingsItemIcon(
    pro: FastFontAwesomeIcons.facebookF,
    free: FontAwesomeIcons.facebookF,
  ),
  FastSettingsItems.website: FastSettingsItemIcon(
    pro: FastFontAwesomeIcons.lightHouse,
    free: FontAwesomeIcons.house,
  ),
  FastSettingsItems.share: FastSettingsItemIcon(
    pro: FastFontAwesomeIcons.lightArrowUpRightFromSquare,
    free: FontAwesomeIcons.share,
  ),
  FastSettingsItems.rateUs: FastSettingsItemIcon(
    pro: FastFontAwesomeIcons.lightThumbsUp,
    free: FontAwesomeIcons.thumbsUp,
  ),
  FastSettingsItems.privacyPolicy: FastSettingsItemIcon(
    pro: FastFontAwesomeIcons.lightUserSecret,
    free: FontAwesomeIcons.userSecret,
  ),
  FastSettingsItems.termsOfService: FastSettingsItemIcon(
    pro: FastFontAwesomeIcons.lightFileContract,
    free: FontAwesomeIcons.fileContract,
  ),
  FastSettingsItems.disclaimer: FastSettingsItemIcon(
    pro: FastFontAwesomeIcons.lightBullhorn,
    free: FontAwesomeIcons.bullhorn,
  ),
  FastSettingsItems.contactUs: FastSettingsItemIcon(
    pro: FastFontAwesomeIcons.lightLifeRing,
    free: FontAwesomeIcons.lifeRing,
  ),
  FastSettingsItems.bugReport: FastSettingsItemIcon(
    pro: FastFontAwesomeIcons.lightBug,
    free: FontAwesomeIcons.bug,
  ),
  FastSettingsItems.appearance: FastSettingsItemIcon(
    pro: FastFontAwesomeIcons.lightPalette,
    free: FontAwesomeIcons.palette,
  ),
  FastSettingsItems.language: FastSettingsItemIcon(
    pro: FastFontAwesomeIcons.lightGlobe,
    free: FontAwesomeIcons.globe,
  ),
  FastSettingsItems.calculator: FastSettingsItemIcon(
    pro: FastFontAwesomeIcons.lightCalculatorSimple,
    free: FontAwesomeIcons.calculator,
  ),
};
