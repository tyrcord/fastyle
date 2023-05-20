import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingua_core/lingua_core.dart';
import 'package:lingua_onboarding/generated/codegen_loader.g.dart';
import 'package:lingua_onboarding/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import './routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr')],
      useOnlyLangCode: true,
      assetLoader: LinguaLoader(
        mapLocales: LinguaLoader.mergeMapLocales([
          OnboardingCodegenLoader.mapLocales,
        ]),
      ),
      path: 'i18n', // fake path, just to make the example work
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FastApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routes: kAppRoutes,
      home: FastSectionPage(
        titleText: 'Fastyle Onboarding',
        contentPadding: EdgeInsets.zero,
        showAppBar: false,
        child: Builder(
          builder: (context) {
            return FastNavigationListView(
              items: [
                FastItem(
                  labelText:
                      OnboardingLocaleKeys.onboarding_notifications_title.tr(),
                  value: 'notifications',
                ),
                FastItem(
                  labelText: OnboardingLocaleKeys
                      .onboarding_personalized_ads_title
                      .tr(),
                  value: 'ads',
                ),
              ],
              onSelectionChanged: (FastItem<dynamic> value) {
                if (value.value == 'notifications') {
                  GoRouter.of(context).go('/notifications');
                } else if (value.value == 'ads') {
                  GoRouter.of(context).go('/ads');
                }
              },
            );
          },
        ),
      ),
    );
  }
}
