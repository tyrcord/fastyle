import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final kAppRoutes = [
  GoRoute(
    path: 'all',
    builder: (context, state) => FastSectionPage(
      contentPadding: EdgeInsets.zero,
      child: const FastBody(
        text: 'TODO',
      ),
    ),
  ),
  GoRoute(
    path: 'languages',
    builder: (context, state) => FastSectionPage(
      contentPadding: EdgeInsets.zero,
      child: const FastBody(
        text: 'TODO',
      ),
    ),
  ),
  GoRoute(
    path: 'theme',
    builder: (context, state) => const FastThemeSettingPage(),
  ),
];
