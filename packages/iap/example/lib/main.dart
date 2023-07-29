// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_dart/fastyle_dart.dart' hide FastApp;
import 'package:lingua_core/lingua_core.dart';

import 'package:lingua_purchases/generated/codegen_loader.g.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';

// Project imports:
import './routes.dart';

final kAppInfo = kFastAppInfo.copyWith(
  appName: 'Fastyle Settings',
  databaseVersion: 0,
  supportedLocales: const [
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('es'),
    Locale('it'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ],
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
      routes: kAppRoutes,
      appInformation: kAppInfo,
      homeBuilder: (context) => buildHome(context),
      assetLoader: LinguaLoader(
        mapLocales: LinguaLoader.mergeMapLocales([
          PurchasesCodegenLoader.mapLocales,
        ]),
      ),
    );
  }

  Widget buildHome(BuildContext context) {
    return FastSectionPage(
      titleText: PurchasesLocaleKeys.purchases_label_go_premium.tr(),
      showAppBar: false,
      child: Column(
        children: [],
      ),
    );
  }
}
