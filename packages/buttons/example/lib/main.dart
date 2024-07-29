// Flutter imports:
import 'package:fastyle_buttons_example/sections/animated.dart';
import 'package:fastyle_buttons_example/sections/text.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:go_router/go_router.dart';

import 'package:fastyle_buttons_example/sections/actions.dart';
import 'package:fastyle_buttons_example/sections/pending.dart';
import 'package:fastyle_buttons_example/sections/navigation.dart';
import 'package:fastyle_buttons_example/sections/toolbar.dart';

final kAppInfo = kFastAppInfo.copyWith(
  appName: 'Fastyle Buttons',
  databaseVersion: 0,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FastApp(
      appInformation: kAppInfo,
      routesForMediaType: (mediaType) => [
        GoRoute(path: '/', builder: (context, __) => const HomePage()),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FastSectionPage(
      titleText: 'Buttons',
      showAppBar: false,
      isViewScrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButtonsSection(),
          kFastVerticalSizedBox16,
          PendingButtonsSection(),
          kFastVerticalSizedBox16,
          ActionButtonsSection(),
          kFastVerticalSizedBox16,
          ToolbarButtonsSection(),
          kFastVerticalSizedBox16,
          NavigationButtonsSection(),
          kFastVerticalSizedBox16,
          AnimatedButtonsSection(),
          kFastVerticalSizedBox16,
        ],
      ),
    );
  }
}
