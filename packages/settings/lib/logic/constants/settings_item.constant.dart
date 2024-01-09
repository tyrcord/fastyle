// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_calculator/generated/locale_keys.g.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:lingua_help/generated/locale_keys.g.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_settings/fastyle_settings.dart';

const _emptyItemDescriptor = FastListItemDescriptor(
  trailing: SizedBox.shrink(),
);

const kFastSettingsItemDescriptors = {
  FastSettingsItems.twitter: FastItem(
    labelText: 'X',
    value: 'action://twitter',
    descriptor: _emptyItemDescriptor,
  ),
  FastSettingsItems.facebook: FastItem(
    value: 'action://facebook',
    descriptor: _emptyItemDescriptor,
    labelText: 'Facebook',
  ),
  FastSettingsItems.website: FastItem(
    labelText: CoreLocaleKeys.core_label_website,
    descriptor: _emptyItemDescriptor,
    value: 'action://site',
  ),
  FastSettingsItems.share: FastItem(
    labelText: CoreLocaleKeys.core_label_share_app,
    descriptor: _emptyItemDescriptor,
    value: 'action://share',
  ),
  FastSettingsItems.rateUs: FastItem(
    labelText: SettingsLocaleKeys.settings_label_rate_us,
    descriptor: _emptyItemDescriptor,
    value: 'action://rate-us',
  ),
  FastSettingsItems.contactUs: FastItem(
    labelText: SettingsLocaleKeys.settings_label_help_and_support,
    descriptor: _emptyItemDescriptor,
    value: 'action://contact-us',
  ),
  FastSettingsItems.bugReport: FastItem(
    labelText: SettingsLocaleKeys.settings_label_submit_bug_report,
    descriptor: _emptyItemDescriptor,
    value: 'action://bug-report',
  ),
  FastSettingsItems.privacyPolicy: FastItem(
    labelText: SettingsLocaleKeys.settings_label_privacy_policy,
    value: '/settings/privacy-policy',
  ),
  FastSettingsItems.termsOfService: FastItem(
    labelText: SettingsLocaleKeys.settings_label_terms_of_service,
    value: '/settings/terms-of-service',
  ),
  FastSettingsItems.disclaimer: FastItem(
    labelText: SettingsLocaleKeys.settings_label_disclaimer,
    value: '/settings/disclaimer',
  ),
  FastSettingsItems.appearance: FastItem(
    labelText: SettingsLocaleKeys.settings_label_appearance,
    value: '/settings/appearance',
  ),
  FastSettingsItems.language: FastItem(
    labelText: SettingsLocaleKeys.settings_label_language,
    value: '/settings/language',
  ),
  FastSettingsItems.calculator: FastItem(
    labelText: CalculatorLocaleKeys.calculator_label_calculator,
    value: '/settings/calculator',
  ),
  FastSettingsItems.manual: FastItem(
    labelText: HelpLocaleKeys.help_label_manual,
    value: '/settings/manual',
  ),
  FastSettingsItems.manuals: FastItem(
    labelText: HelpLocaleKeys.help_label_manuals,
    value: '/settings/manuals',
  ),
};

const kFastSettingsItemIcons = {
  FastSettingsItems.twitter: FastSettingsItemIcon(
    pro: FastFontAwesomeIcons.xTwitter,
    free: FontAwesomeIcons.xTwitter,
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
  FastSettingsItems.manual: FastSettingsItemIcon(
    pro: FastFontAwesomeIcons.lightBook,
    free: FontAwesomeIcons.book,
  ),
  FastSettingsItems.manuals: FastSettingsItemIcon(
    pro: FastFontAwesomeIcons.lightBooks,
    free: FontAwesomeIcons.book,
  ),
};
