import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';
import 'package:tstore/tstore.dart';

/// Represents information about a fast app.
class FastAppInfoDocument extends TDocument {
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

  final int? previousDatabaseVersion;

  /// The device's language code.
  final String? deviceLanguageCode;

  /// The device's country code.
  final String? deviceCountryCode;

  /// The supported locales of the application.
  final List<Locale> supportedLocales;

  /// Creates an instance of [FastAppInfoDocument].
  const FastAppInfoDocument({
    this.appVersion,
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
    this.appBuildNumber,
    this.promoUrl,
    this.previousDatabaseVersion,
    this.deviceLanguageCode,
    this.deviceCountryCode,
    int? askForReviewMinLaunches,
    int? askForReviewMinDays,
    int? remindForReviewMinLaunches,
    int? remindForReviewMinDays,
    bool? hasDisclaimer,
    String? appName,
    List<Locale>? supportedLocales,
    int? appLaunchCounter,
  })  : appName = appName ?? kFastEmptyString,
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

  factory FastAppInfoDocument.fromBlocState(FastAppInfoBlocState state) {
    return FastAppInfoDocument(
      appAuthor: state.appAuthor,
      appBuildNumber: state.appBuildNumber,
      appIdentifier: state.appIdentifier,
      appTermsOfServiceUrl: state.appTermsOfServiceUrl,
      appPrivacyPolicyUrl: state.appPrivacyPolicyUrl,
      appDisclaimerUrl: state.appDisclaimerUrl,
      supportEmail: state.supportEmail,
      bugReportEmail: state.bugReportEmail,
      facebookUrl: state.facebookUrl,
      homepageUrl: state.homepageUrl,
      instagramUrl: state.instagramUrl,
      shareAppUrl: state.shareAppUrl,
      databaseVersion: state.databaseVersion,
      googlePlayIdentifier: state.googlePlayIdentifier,
      appStoreIdentifier: state.appStoreIdentifier,
      productIdentifiers: state.productIdentifiers,
      premiumProductIdentifier: state.premiumProductIdentifier,
      promoUrl: state.promoUrl,
      appVersion: state.appVersion,
      askForReviewMinLaunches: state.askForReviewMinLaunches,
      askForReviewMinDays: state.askForReviewMinDays,
      remindForReviewMinLaunches: state.remindForReviewMinLaunches,
      remindForReviewMinDays: state.remindForReviewMinDays,
      hasDisclaimer: state.hasDisclaimer,
      appName: state.appName,
      appLaunchCounter: state.appLaunchCounter,
      previousDatabaseVersion: state.previousDatabaseVersion,
      deviceLanguageCode: state.deviceLanguageCode,
      deviceCountryCode: state.deviceCountryCode,
      supportedLocales: state.supportedLocales,
    );
  }

  factory FastAppInfoDocument.fromJson(Map<String, dynamic> json) {
    final productIdentifiers = json['productIdentifiers'] as List<dynamic>?;
    List<String>? productIdentifiersSafe = [];

    if (productIdentifiers != null) {
      for (var productIdentifier in productIdentifiers) {
        if (productIdentifier is String) {
          productIdentifiersSafe.add(productIdentifier);
        }
      }
    }

    return FastAppInfoDocument(
      // Ignore supportedLocales
      hasDisclaimer:
          json['hasDisclaimer'] as bool? ?? kFastAppSettingsHasDisclaimer,
      appName: json['appName'] as String? ?? kFastEmptyString,
      askForReviewMinLaunches: json['askForReviewMinLaunches'] as int? ??
          kFastAppSettingsAskForReviewMinLaunches,
      askForReviewMinDays: json['askForReviewMinDays'] as int? ??
          kFastAppSettingsAskForReviewMinDays,
      remindForReviewMinLaunches: json['remindForReviewMinLaunches'] as int? ??
          kFastAppSettingsRemindForReviewMinLaunches,
      remindForReviewMinDays: json['remindForReviewMinDays'] as int? ??
          kFastAppSettingsRemindForReviewMinDays,
      appVersion: json['appVersion'] as String?,
      appBuildNumber: json['appBuildNumber'] as String?,
      appAuthor: json['appAuthor'] as String?,
      appIdentifier: json['appIdentifier'] as String?,
      appTermsOfServiceUrl: json['appTermsOfServiceUrl'] as String?,
      appPrivacyPolicyUrl: json['appPrivacyPolicyUrl'] as String?,
      appDisclaimerUrl: json['appDisclaimerUrl'] as String?,
      supportEmail: json['supportEmail'] as String?,
      bugReportEmail: json['bugReportEmail'] as String?,
      facebookUrl: json['facebookUrl'] as String?,
      homepageUrl: json['homepageUrl'] as String?,
      instagramUrl: json['instagramUrl'] as String?,
      shareAppUrl: json['shareAppUrl'] as String?,
      databaseVersion: json['databaseVersion'] as int?,
      googlePlayIdentifier: json['googlePlayIdentifier'] as String?,
      appStoreIdentifier: json['appStoreIdentifier'] as String?,
      productIdentifiers: productIdentifiersSafe,
      premiumProductIdentifier: json['premiumProductIdentifier'] as String?,
      promoUrl: json['promoUrl'] as String?,
      appLaunchCounter: json['appLaunchCounter'] as int? ?? 0,
      previousDatabaseVersion: json['previousDatabaseVersion'] as int?,
      deviceLanguageCode: json['deviceLanguageCode'] as String?,
      deviceCountryCode: json['deviceCountryCode'] as String?,
    );
  }

  @override
  FastAppInfoDocument copyWith({
    String? appName,
    String? appVersion,
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
    String? appBuildNumber,
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
  }) {
    return FastAppInfoDocument(
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
      appLaunchCounter: appLaunchCounter ?? this.appLaunchCounter,
      askForReviewMinLaunches:
          askForReviewMinLaunches ?? this.askForReviewMinLaunches,
      askForReviewMinDays: askForReviewMinDays ?? this.askForReviewMinDays,
      remindForReviewMinLaunches:
          remindForReviewMinLaunches ?? this.remindForReviewMinLaunches,
      remindForReviewMinDays:
          remindForReviewMinDays ?? this.remindForReviewMinDays,
      promoUrl: promoUrl ?? this.promoUrl,
      previousDatabaseVersion:
          previousDatabaseVersion ?? this.previousDatabaseVersion,
      deviceLanguageCode: deviceLanguageCode ?? this.deviceLanguageCode,
      deviceCountryCode: deviceCountryCode ?? this.deviceCountryCode,
      supportedLocales: supportedLocales ?? this.supportedLocales,
    );
  }

  @override
  FastAppInfoDocument merge(covariant FastAppInfoDocument model) {
    return copyWith(
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
      appLaunchCounter: model.appLaunchCounter,
      askForReviewMinLaunches: model.askForReviewMinLaunches,
      askForReviewMinDays: model.askForReviewMinDays,
      remindForReviewMinLaunches: model.remindForReviewMinLaunches,
      remindForReviewMinDays: model.remindForReviewMinDays,
      promoUrl: model.promoUrl,
      previousDatabaseVersion: model.previousDatabaseVersion,
      deviceLanguageCode: model.deviceLanguageCode,
      deviceCountryCode: model.deviceCountryCode,
      supportedLocales: model.supportedLocales,
    );
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        // Ignore supportedLocales
        'appName': appName,
        'appVersion': appVersion,
        'appBuildNumber': appBuildNumber,
        'appAuthor': appAuthor,
        'appIdentifier': appIdentifier,
        'appTermsOfServiceUrl': appTermsOfServiceUrl,
        'appPrivacyPolicyUrl': appPrivacyPolicyUrl,
        'appDisclaimerUrl': appDisclaimerUrl,
        'supportEmail': supportEmail,
        'bugReportEmail': bugReportEmail,
        'facebookUrl': facebookUrl,
        'homepageUrl': homepageUrl,
        'instagramUrl': instagramUrl,
        'shareAppUrl': shareAppUrl,
        'databaseVersion': databaseVersion,
        'hasDisclaimer': hasDisclaimer,
        'googlePlayIdentifier': googlePlayIdentifier,
        'appStoreIdentifier': appStoreIdentifier,
        'productIdentifiers': productIdentifiers,
        'premiumProductIdentifier': premiumProductIdentifier,
        'askForReviewMinLaunches': askForReviewMinLaunches,
        'askForReviewMinDays': askForReviewMinDays,
        'remindForReviewMinLaunches': remindForReviewMinLaunches,
        'remindForReviewMinDays': remindForReviewMinDays,
        'promoUrl': promoUrl,
        'appLaunchCounter': appLaunchCounter,
        'previousDatabaseVersion': previousDatabaseVersion,
        'deviceLanguageCode': deviceLanguageCode,
        'deviceCountryCode': deviceCountryCode,
      };

  @override
  FastAppInfoDocument clone() => copyWith();

  @override
  List<Object?> get props => [
        appName,
        appVersion,
        appAuthor,
        appIdentifier,
        appTermsOfServiceUrl,
        appPrivacyPolicyUrl,
        appDisclaimerUrl,
        supportEmail,
        bugReportEmail,
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
        appBuildNumber,
        askForReviewMinLaunches,
        askForReviewMinDays,
        remindForReviewMinLaunches,
        remindForReviewMinDays,
        promoUrl,
        appLaunchCounter,
        previousDatabaseVersion,
        deviceLanguageCode,
        deviceCountryCode,
        supportedLocales,
      ];
}
