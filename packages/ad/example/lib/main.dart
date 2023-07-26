import 'package:fastyle_ad_example/routes.dart';

import 'package:flutter/material.dart';
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_dart/fastyle_dart.dart' hide FastApp;
import 'package:go_router/go_router.dart';
import 'package:lingua_ad/generated/codegen_loader.g.dart';
import 'package:lingua_core/lingua_core.dart';
import 'package:tbloc/tbloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

final kAppInfo = kFastAppInfo.copyWith(
  appName: 'Fastyle Ads',
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FastApp(
      appInformation: kAppInfo,
      assetLoader: LinguaLoader(
        mapLocales: LinguaLoader.mergeMapLocales([
          AdCodegenLoader.mapLocales,
        ]),
      ),
      routes: kAppRoutes,
      blocProviders: [
        BlocProvider(bloc: FastAdInfoBloc()),
      ],
      loaderJobs: [
        FastAdInfoJob(),
      ],
      homeBuilder: (BuildContext context) => const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      titleText: 'Fastyle Ads Demo',
      contentPadding: EdgeInsets.zero,
      child: FastNavigationListView(
        onSelectionChanged: (FastItem<String> item) {
          GoRouter.of(context).go('/${item.value}');
        },
        items: const [
          FastItem(labelText: 'Admob Native Ads', value: 'admob-native'),
          FastItem(labelText: 'Smart Ads', value: 'smart'),
          FastItem(labelText: 'Custom Ads', value: 'custom'),
          FastItem(labelText: 'Loading Ads', value: 'loading'),
        ],
      ),
    );
  }
}
