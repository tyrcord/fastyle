// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

export './edge_insets.constants.dart';
export './sized_box.constants.dart';
export './app_info.constants.dart';

const kFastSettingThemeModeMap = {
  'system': ThemeMode.system,
  'light': ThemeMode.light,
  'dark': ThemeMode.dark,
};

const kFastSettingsThemeMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

/// Default store key names.
const kFastAppSettingStoreName = 'fastAppSettings';
const kFastAppInfoStoreName = 'fastAppInfo';
const kFastAppFeaturesStoreName = 'fastAppFeatures';
const kFastAppDictStoreName = 'fastAppDict';
const kFastAppOnboardingStoreName = 'fastAppOnboarding';

// Default App setting values.
final kFastSettingsDefaultTheme = kFastSettingsThemeMap[ThemeMode.system]!;
const kFastAppSettingsPrimaryCurrencyCode = 'usd';
const kFastSettingsDefaultLanguageCode = 'en';
const kFastAppSettingsSaveEntry = true;

/// Default app constant values.

/// The default locale for the Fast App Settings.
const kFastAppSettingsDefaultLocale = Locale(kFastSettingsDefaultLanguageCode);

/// The list of supported locales for the Fast App Settings.
const kFastAppSettingsSupportedLocales = [kFastAppSettingsDefaultLocale];

/// The minimum number of app launches before reminding the user for a review.
const kFastAppSettingsRemindForReviewMinLaunches = 10;

/// The minimum number of app launches before asking the user for a review.
const kFastAppSettingsAskForReviewMinLaunches = 10;

/// The minimum number of days before reminding the user for a review.
const kFastAppSettingsRemindForReviewMinDays = 7;

/// The timeout duration for asynchronous operations in Fast App.
const kFastAsyncTimeout = Duration(seconds: 30);

/// The minimum number of days before asking the user for a review.
const kFastAppSettingsAskForReviewMinDays = 7;

/// Indicates whether Fast App has a disclaimer.
const kFastAppSettingsHasDisclaimer = false;

/// The list of default routes for Fast App.
const kFastDefaultRoutes = <GoRoute>[];

/// The path to the localization files for Fast App.
const kFastLocalizationPath = 'i18n/';

/// The duration to delay before showing the loader in Fast App.
const kFastDelayBeforeShowingLoader = Duration(seconds: 1);

/// Default duration before refreshing data in Fast App.
const kFastRefreshTimeout = Duration(seconds: 60);

//TODO: @need-review: code from fastyle_dart

// Strings

const kFastClearSelectionText = 'Clear Selection';
const kFastSearchPlaceholderText = 'Search...';
const kFastSelectTitleText = 'Select';
const kFastNoItemsString = 'No items';
const kFastButtonLabel = 'Button';
const kFastCancelText = 'cancel';
const kFastNoneString = 'none';
const kFastValidText = 'valid';
const kFastPanelText = 'panel';
const kFastAllString = 'all';
const kFastDoneText = 'done';
const kFastNextText = 'next';
const kFastSkipText = 'skip';
const kFastEmptyString = '';

// Sizes

const kFastIconSizeXxs = 16.0;
const kFastIconSizeXs = 18.0;
const kFastIconSizeSmall = 20.0;
const kFastIconSizeMedium = 24.0;
const kFastIconSizeLarge = 28.0;
const kFastIconSizeXl = 32.0;
const kFastIconSizeXxl = 48.0;

// Image Sizes

const kFastImageizeXs = 16.0;
const kFastImageSizeSmall = 24.0;
const kFastImageSizeMedium = 32.0;
const kFastImageSizeLarge = 48.0;
const kFastImageSizeXl = 64.0;
const kFastImageSizeXxl = 128.0;
const kFastImageSizeXxxl = 160.0;

const kFastLineHeight = 1.2;

// Radius

const kFastBorderRadius = 12.0;
const kFastBlurRadius = 3.0;
const kFastSplashRadius = 18.0;

// Options

final kFastFuzzyOptions = FuzzyOptions(
  isCaseSensitive: false,
  shouldNormalize: true,
  shouldSort: true,
  location: 0,
  threshold: 0.25,
  distance: 100,
  findAllMatches: false,
  minMatchCharLength: 2,
);

final kFastFastItemFuzzyOptions = FuzzyOptions(
  isCaseSensitive: kFastFuzzyOptions.isCaseSensitive,
  shouldNormalize: kFastFuzzyOptions.shouldNormalize,
  shouldSort: kFastFuzzyOptions.shouldSort,
  location: kFastFuzzyOptions.location,
  threshold: kFastFuzzyOptions.threshold,
  distance: kFastFuzzyOptions.distance,
  findAllMatches: kFastFuzzyOptions.findAllMatches,
  minMatchCharLength: kFastFuzzyOptions.minMatchCharLength,
  keys: [
    WeightedKey<FastItem>(
      name: 'labelText',
      getter: (FastItem item) => item.labelText,
      weight: 1,
    ),
    WeightedKey(
      name: 'descriptionText',
      getter: (FastItem item) => item.descriptionText ?? kFastEmptyString,
      weight: 0.5,
    ),
  ],
);

// Alpha

const kDisabledAlpha = 72;

// Duration

const kFastDebounceTimeDuration = Duration(milliseconds: 300);
const kFastTrottleTimeDuration = Duration(seconds: 1);

// Languages

const kFastSupportedLocales = <Locale>[Locale('en', 'US')];

// Icons

const kFastCloseIcon = FaIcon(FontAwesomeIcons.xmark);
const kFastBackIcon = FaIcon(FontAwesomeIcons.chevronLeft);
const kFastDoneIcon = FaIcon(FontAwesomeIcons.check);
const kFastClearSearchIcon = FaIcon(FontAwesomeIcons.trash);
const kFastNavigationTrailingIcon = FaIcon(FontAwesomeIcons.chevronRight);

const kFastExpandedHeight = 176.0;