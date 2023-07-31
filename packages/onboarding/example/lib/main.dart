// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:go_router/go_router.dart';
import 'package:lingua_core/lingua_core.dart';
import 'package:lingua_onboarding/generated/codegen_loader.g.dart';
import 'package:lingua_onboarding/generated/locale_keys.g.dart';

// Project imports:
import './routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      routes: kAppRoutes,
      homeBuilder: (_) => FastSectionPage(
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
                FastItem(
                  labelText:
                      OnboardingLocaleKeys.onboarding_user_currency_title.tr(),
                  value: 'currency',
                ),
                FastItem(
                  labelText: OnboardingLocaleKeys
                      .onboarding_restore_premium_title
                      .tr(),
                  value: 'premium',
                ),
              ],
              onSelectionChanged: (FastItem<dynamic> value) {
                if (value.value == 'notifications') {
                  GoRouter.of(context).go('/notifications');
                } else if (value.value == 'ads') {
                  GoRouter.of(context).go('/ads');
                } else if (value.value == 'currency') {
                  GoRouter.of(context).go('/currency');
                } else if (value.value == 'premium') {
                  GoRouter.of(context).go('/premium');
                }
              },
            );
          },
        ),
      ),
    );
  }
}
