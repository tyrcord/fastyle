// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:go_router/go_router.dart';
import 'package:lingua_ad/generated/codegen_loader.g.dart';
import 'package:lingua_core/lingua_core.dart';
import 'package:lingua_purchases/generated/codegen_loader.g.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad_example/routes.dart';

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

class MyApp extends StatelessWidget with FastAdInformationJobDelegate {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FastApp(
      appInformation: kAppInfo,
      assetLoader: LinguaLoader.withLocales(mapLocales: [
        AdCodegenLoader.mapLocales,
        PurchasesCodegenLoader.mapLocales,
      ]),
      routes: kAppRoutes,
      blocProviders: [
        BlocProvider(bloc: FastAdInfoBloc()),
        BlocProvider(bloc: FastSplashAdBloc()),
        BlocProvider(bloc: FastRewardedAdBloc()),
      ],
      loaderJobs: [
        FastAdInfoJob(delegate: this),
        FastSplashAdJob(),
        FastRewardedAdJob(),
      ],
      homeBuilder: (BuildContext context) => const MyHomePage(),
    );
  }

  @override
  FastAdInfo onGetAdInformationModel(BuildContext context) {
    return const FastAdInfo(
      adServiceUriAuthority: 'services.lumen.tyrcord.com',
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      titleText: 'Fastyle Ads Demo',
      child: FastNavigationListView(
        onSelectionChanged: (FastItem<String> item) {
          GoRouter.of(context).go('/${item.value}');
        },
        items: const [
          FastItem(labelText: 'Smart Native Ads', value: 'smart-native'),
          FastItem(labelText: 'Custom Ads', value: 'custom'),
          FastItem(labelText: 'Loading Ads', value: 'loading'),
          FastItem(labelText: 'Rewarded Ads', value: 'rewarded'),
        ],
      ),
    );
  }
}
