// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:go_router/go_router.dart';

final kAppRoutes = [
  GoRoute(
    path: 'all',
    builder: (context, state) => const FastSectionPage(
      contentPadding: EdgeInsets.zero,
      child: FastBody(
        text: 'TODO',
      ),
    ),
  ),
  GoRoute(
    path: 'languages',
    builder: (context, state) => const FastSettingsLanguagePage(),
  ),
  GoRoute(
    path: 'appearance',
    builder: (context, state) => const FastSettingsThemePage(),
  ),
  GoRoute(
    path: 'disclaimer',
    builder: (context, state) => const FastSettingsDisclaimerPage(),
  ),
  GoRoute(
    path: 'tos',
    builder: (context, state) => const FastSettingsTermsOfServicePage(),
  ),
  GoRoute(
    path: 'privacy-policy',
    builder: (context, state) => const FastSettingsPrivacyPolicyPage(),
  ),
];
