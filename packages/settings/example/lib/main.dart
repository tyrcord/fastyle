import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:lingua_core/lingua_core.dart';
import 'package:tbloc_dart/tbloc_dart.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import './routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(const MyApp());

  // runApp(
  //   EasyLocalization(
  //     supportedLocales: const [Locale('en'), Locale('fr')],
  //     useOnlyLangCode: true,
  //     assetLoader: LinguaLoader(
  //       mapLocales: LinguaLoader.mergeMapLocales([]),
  //     ),
  //     path: 'i18n', // fake path, just to make the example work
  //     child: const MyApp(),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      blocProviders: [
        BlocProvider(bloc: FastSettingsBloc()),
      ],
      child: FastApp(
        // localizationsDelegates: context.localizationDelegates,
        // supportedLocales: context.supportedLocales,
        // locale: context.locale,
        routes: kAppRoutes,
        loaderJobs: [
          FastSettingsJob(),
        ],
        home: FastSettingsThemeListener(
          child: buildHome(context),
        ),
      ),
    );
  }

  buildHome(BuildContext context) {
    return FastSectionPage(
      titleText: 'Fastyle Settings',
      contentPadding: EdgeInsets.zero,
      showAppBar: false,
      child: Builder(
        builder: (context) {
          return FastNavigationListView(
            items: const [
              FastItem(
                labelText: 'all',
                value: '/all',
              ),
              FastItem(
                labelText: 'languages',
                value: '/languages',
              ),
              FastItem(
                labelText: 'theme',
                value: '/theme',
              ),
            ],
            onSelectionChanged: (FastItem<String> item) {
              if (item.value != null) {
                GoRouter.of(context).go(item.value!);
              }
            },
          );
        },
      ),
    );
  }
}
