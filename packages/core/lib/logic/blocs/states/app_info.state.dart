// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// The [FastAppInfoBlocState] class represents the state of the application's
/// information.
class FastAppInfoBlocState extends BlocState {
  /// The name of the app.
  final String appName;

  /// The version of the app.
  final String? appVersion;

  /// The build number of the app.
  final String? appBuildNumber;

  /// The author of the app.
  final String? appAuthor;

  /// The identifier of the app.
  final String? appIdentifier;

  /// The URL to the app's terms of service.
  final String? appTermsOfServiceUrl;

  /// The URL to the app's privacy policy.
  final String? appPrivacyPolicyUrl;

  /// The URL to the app's disclaimer.
  final String? appDisclaimerUrl;

  /// The support email for the app.
  final String? supportEmail;

  /// The bug report email for the app.
  final String? bugReportEmail;

  /// The Facebook URL for the app.
  final String? facebookUrl;

  /// The homepage URL for the app.
  final String? homepageUrl;

  /// The Instagram URL for the app.
  final String? instagramUrl;

  /// The share app URL for the app.
  final String? shareAppUrl;

  /// The database version of the app.
  final int? databaseVersion;

  /// Indicates whether the app has a disclaimer.
  final bool hasDisclaimer;

  /// The Google Play identifier for the app.
  final String? googlePlayIdentifier;

  /// The App Store identifier for the app.
  final String? appStoreIdentifier;

  /// The list of product identifiers for in-app purchases.
  final List<String>? productIdentifiers;

  /// The premium product identifier for the app.
  final String? premiumProductIdentifier;

  /// The minimum number of launches before asking for a review.
  final int askForReviewMinLaunches;

  /// The minimum number of days before asking for a review.
  final int askForReviewMinDays;

  /// The minimum number of launches before reminding for a review.
  final int remindForReviewMinLaunches;

  /// The minimum number of days before reminding for a review.
  final int remindForReviewMinDays;

  /// The URL for a promotional offer for the app.
  final String? promoUrl;

  /// The app launch counter.
  final int appLaunchCounter;

  /// The previous database version of the app.
  final int? previousDatabaseVersion;

  /// The device's language code.
  final String deviceLanguageCode;

  /// The device's country code.
  final String? deviceCountryCode;

  bool get isFirstLaunch => appLaunchCounter <= 1;

  /// The supported locales of the application.
  final List<Locale> supportedLocales;

  /// The last modified date of the app disclaimer.
  final DateTime? appDisclaimerLastModified;

  /// The last modified date of the app privacy policy.
  final DateTime? appPrivacyPolicyLastModified;

  /// The last modified date of the app terms of service.
  final DateTime? appTermsOfServiceLastModified;

  /// Constructs a [FastAppInfoBlocState] with the provided parameters.
  FastAppInfoBlocState({
    super.isInitializing,
    super.isInitialized,
    this.appVersion,
    this.appBuildNumber,
    this.appAuthor,
    this.appIdentifier,
    this.appTermsOfServiceUrl,
    this.appPrivacyPolicyUrl,
    this.appDisclaimerUrl,
    this.supportEmail,
    this.bugReportEmail,
    this.facebookUrl,
    this.homepageUrl,
    this.instagramUrl,
    this.shareAppUrl,
    this.databaseVersion,
    this.googlePlayIdentifier,
    this.appStoreIdentifier,
    this.productIdentifiers,
    this.premiumProductIdentifier,
    this.previousDatabaseVersion,
    this.promoUrl,
    this.deviceCountryCode,
    this.appDisclaimerLastModified,
    this.appPrivacyPolicyLastModified,
    this.appTermsOfServiceLastModified,
    List<Locale>? supportedLocales,
    int? askForReviewMinLaunches,
    int? askForReviewMinDays,
    int? remindForReviewMinLaunches,
    int? remindForReviewMinDays,
    bool? hasDisclaimer,
    String? appName,
    String? deviceLanguageCode,
    int? appLaunchCounter,
  })  : appName = appName ?? kFastEmptyString,
        deviceLanguageCode =
            deviceLanguageCode ?? kFastSettingsDefaultLanguageCode,
        askForReviewMinLaunches =
            askForReviewMinLaunches ?? kFastAppSettingsAskForReviewMinLaunches,
        remindForReviewMinLaunches = remindForReviewMinLaunches ??
            kFastAppSettingsRemindForReviewMinLaunches,
        askForReviewMinDays =
            askForReviewMinDays ?? kFastAppSettingsAskForReviewMinDays,
        remindForReviewMinDays =
            remindForReviewMinDays ?? kFastAppSettingsRemindForReviewMinDays,
        hasDisclaimer = hasDisclaimer ?? kFastAppSettingsHasDisclaimer,
        supportedLocales = supportedLocales ?? kFastAppSettingsSupportedLocales,
        appLaunchCounter = appLaunchCounter ?? 0;

  factory FastAppInfoBlocState.fromDocument(FastAppInfoDocument document) {
    return FastAppInfoBlocState(
      appAuthor: document.appAuthor,
      appBuildNumber: document.appBuildNumber,
      appIdentifier: document.appIdentifier,
      appTermsOfServiceUrl: document.appTermsOfServiceUrl,
      appPrivacyPolicyUrl: document.appPrivacyPolicyUrl,
      appDisclaimerUrl: document.appDisclaimerUrl,
      supportEmail: document.supportEmail,
      bugReportEmail: document.bugReportEmail,
      facebookUrl: document.facebookUrl,
      homepageUrl: document.homepageUrl,
      instagramUrl: document.instagramUrl,
      shareAppUrl: document.shareAppUrl,
      databaseVersion: document.databaseVersion,
      googlePlayIdentifier: document.googlePlayIdentifier,
      appStoreIdentifier: document.appStoreIdentifier,
      productIdentifiers: document.productIdentifiers,
      premiumProductIdentifier: document.premiumProductIdentifier,
      promoUrl: document.promoUrl,
      appVersion: document.appVersion,
      askForReviewMinLaunches: document.askForReviewMinLaunches,
      askForReviewMinDays: document.askForReviewMinDays,
      remindForReviewMinLaunches: document.remindForReviewMinLaunches,
      remindForReviewMinDays: document.remindForReviewMinDays,
      hasDisclaimer: document.hasDisclaimer,
      appName: document.appName,
      appLaunchCounter: document.appLaunchCounter,
      previousDatabaseVersion: document.previousDatabaseVersion,
      deviceLanguageCode: document.deviceLanguageCode,
      deviceCountryCode: document.deviceCountryCode,
      supportedLocales: document.supportedLocales,
      appDisclaimerLastModified: document.appDisclaimerLastModified,
      appPrivacyPolicyLastModified: document.appPrivacyPolicyLastModified,
      appTermsOfServiceLastModified: document.appTermsOfServiceLastModified,
    );
  }

  /// Creates a new [FastAppInfoBlocState] instance with updated properties.
  ///
  /// If a parameter is not provided, the corresponding property of the current
  /// instance is used instead.
  @override
  FastAppInfoBlocState copyWith({
    bool? isInitializing,
    bool? isInitialized,
    String? appName,
    String? appVersion,
    String? appBuildNumber,
    String? appAuthor,
    String? appIdentifier,
    String? appTermsOfServiceUrl,
    String? appPrivacyPolicyUrl,
    String? appDisclaimerUrl,
    String? supportEmail,
    String? bugReportEmail,
    String? facebookUrl,
    String? homepageUrl,
    String? instagramUrl,
    String? shareAppUrl,
    int? databaseVersion,
    bool? hasDisclaimer,
    String? googlePlayIdentifier,
    String? appStoreIdentifier,
    List<String>? productIdentifiers,
    String? premiumProductIdentifier,
    int? askForReviewMinLaunches,
    int? askForReviewMinDays,
    int? remindForReviewMinLaunches,
    int? remindForReviewMinDays,
    String? promoUrl,
    int? appLaunchCounter,
    int? previousDatabaseVersion,
    String? deviceLanguageCode,
    String? deviceCountryCode,
    List<Locale>? supportedLocales,
    DateTime? appDisclaimerLastModified,
    DateTime? appPrivacyPolicyLastModified,
    DateTime? appTermsOfServiceLastModified,
  }) =>
      FastAppInfoBlocState(
        supportedLocales: supportedLocales ?? this.supportedLocales,
        isInitializing: isInitializing ?? this.isInitializing,
        isInitialized: isInitialized ?? this.isInitialized,
        appName: appName ?? this.appName,
        appVersion: appVersion ?? this.appVersion,
        appBuildNumber: appBuildNumber ?? this.appBuildNumber,
        appAuthor: appAuthor ?? this.appAuthor,
        appIdentifier: appIdentifier ?? this.appIdentifier,
        appTermsOfServiceUrl: appTermsOfServiceUrl ?? this.appTermsOfServiceUrl,
        appPrivacyPolicyUrl: appPrivacyPolicyUrl ?? this.appPrivacyPolicyUrl,
        appDisclaimerUrl: appDisclaimerUrl ?? this.appDisclaimerUrl,
        supportEmail: supportEmail ?? this.supportEmail,
        bugReportEmail: bugReportEmail ?? this.bugReportEmail,
        facebookUrl: facebookUrl ?? this.facebookUrl,
        homepageUrl: homepageUrl ?? this.homepageUrl,
        instagramUrl: instagramUrl ?? this.instagramUrl,
        shareAppUrl: shareAppUrl ?? this.shareAppUrl,
        databaseVersion: databaseVersion ?? this.databaseVersion,
        hasDisclaimer: hasDisclaimer ?? this.hasDisclaimer,
        googlePlayIdentifier: googlePlayIdentifier ?? this.googlePlayIdentifier,
        appStoreIdentifier: appStoreIdentifier ?? this.appStoreIdentifier,
        productIdentifiers: productIdentifiers ?? this.productIdentifiers,
        premiumProductIdentifier:
            premiumProductIdentifier ?? this.premiumProductIdentifier,
        askForReviewMinLaunches:
            askForReviewMinLaunches ?? this.askForReviewMinLaunches,
        askForReviewMinDays: askForReviewMinDays ?? this.askForReviewMinDays,
        remindForReviewMinLaunches:
            remindForReviewMinLaunches ?? this.remindForReviewMinLaunches,
        remindForReviewMinDays:
            remindForReviewMinDays ?? this.remindForReviewMinDays,
        promoUrl: promoUrl ?? this.promoUrl,
        appLaunchCounter: appLaunchCounter ?? this.appLaunchCounter,
        previousDatabaseVersion:
            previousDatabaseVersion ?? this.previousDatabaseVersion,
        deviceLanguageCode: deviceLanguageCode ?? this.deviceLanguageCode,
        deviceCountryCode: deviceCountryCode ?? this.deviceCountryCode,
        appDisclaimerLastModified:
            appDisclaimerLastModified ?? this.appDisclaimerLastModified,
        appPrivacyPolicyLastModified:
            appPrivacyPolicyLastModified ?? this.appPrivacyPolicyLastModified,
        appTermsOfServiceLastModified:
            appTermsOfServiceLastModified ?? this.appTermsOfServiceLastModified,
      );

  /// Creates a new [FastAppInfoBlocState] instance with the same property
  /// values as the current instance.
  @override
  FastAppInfoBlocState clone() => copyWith();

  /// Merges the properties of the provided [model] into a new
  /// [FastAppInfoBlocState] instance.
  @override
  FastAppInfoBlocState merge(covariant FastAppInfoBlocState model) {
    return copyWith(
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      appName: model.appName,
      appVersion: model.appVersion,
      appBuildNumber: model.appBuildNumber,
      appAuthor: model.appAuthor,
      appIdentifier: model.appIdentifier,
      appTermsOfServiceUrl: model.appTermsOfServiceUrl,
      appPrivacyPolicyUrl: model.appPrivacyPolicyUrl,
      appDisclaimerUrl: model.appDisclaimerUrl,
      supportEmail: model.supportEmail,
      bugReportEmail: model.bugReportEmail,
      facebookUrl: model.facebookUrl,
      homepageUrl: model.homepageUrl,
      instagramUrl: model.instagramUrl,
      shareAppUrl: model.shareAppUrl,
      databaseVersion: model.databaseVersion,
      hasDisclaimer: model.hasDisclaimer,
      googlePlayIdentifier: model.googlePlayIdentifier,
      appStoreIdentifier: model.appStoreIdentifier,
      productIdentifiers: model.productIdentifiers,
      premiumProductIdentifier: model.premiumProductIdentifier,
      askForReviewMinLaunches: model.askForReviewMinLaunches,
      askForReviewMinDays: model.askForReviewMinDays,
      remindForReviewMinLaunches: model.remindForReviewMinLaunches,
      remindForReviewMinDays: model.remindForReviewMinDays,
      promoUrl: model.promoUrl,
      appLaunchCounter: model.appLaunchCounter,
      previousDatabaseVersion: model.previousDatabaseVersion,
      deviceLanguageCode: model.deviceLanguageCode,
      deviceCountryCode: model.deviceCountryCode,
      supportedLocales: model.supportedLocales,
      appDisclaimerLastModified: model.appDisclaimerLastModified,
      appPrivacyPolicyLastModified: model.appPrivacyPolicyLastModified,
      appTermsOfServiceLastModified: model.appTermsOfServiceLastModified,
    );
  }

  @override
  List<Object?> get props => [
        appName,
        appVersion,
        appBuildNumber,
        appAuthor,
        appIdentifier,
        appTermsOfServiceUrl,
        appPrivacyPolicyUrl,
        appDisclaimerUrl,
        supportEmail,
        bugReportEmail,
        supportedLocales,
        facebookUrl,
        homepageUrl,
        instagramUrl,
        shareAppUrl,
        databaseVersion,
        hasDisclaimer,
        googlePlayIdentifier,
        appStoreIdentifier,
        productIdentifiers,
        premiumProductIdentifier,
        askForReviewMinLaunches,
        askForReviewMinDays,
        remindForReviewMinLaunches,
        remindForReviewMinDays,
        promoUrl,
        appLaunchCounter,
        previousDatabaseVersion,
        deviceLanguageCode,
        deviceCountryCode,
        appDisclaimerLastModified,
        appPrivacyPolicyLastModified,
        appTermsOfServiceLastModified,
      ];
}
