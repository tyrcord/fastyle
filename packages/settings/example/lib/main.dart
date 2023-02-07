import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingua_core/lingua_core.dart';
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
    return FastApp(
      // localizationsDelegates: context.localizationDelegates,
      // supportedLocales: context.supportedLocales,
      // locale: context.locale,
      routes: kAppRoutes,
      home: FastSectionPage(
        titleText: 'Fastyle Settings',
        contentPadding: EdgeInsets.zero,
        showAppBar: false,
        child: Builder(
          builder: (context) {
            return FastNavigationListView(
              items: const [
                FastItem(
                  labelText: 'all',
                  value: 'all',
                ),
                FastItem(
                  labelText: 'languages',
                  value: 'languages',
                ),
              ],
              onSelectionChanged: (FastItem<dynamic> value) {
                if (value.value == 'all') {
                  GoRouter.of(context).go('/all');
                } else if (value.value == 'languages') {
                  GoRouter.of(context).go('/languages');
                }
              },
            );
          },
        ),
      ),
    );
  }
}
