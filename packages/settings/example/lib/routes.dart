import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final kAppRoutes = [
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
    path: 'all',
    builder: (context, state) => FastSectionPage(
      contentPadding: EdgeInsets.zero,
      child: const FastBody(
        text: 'TODO',
      ),
    ),
  ),
];
