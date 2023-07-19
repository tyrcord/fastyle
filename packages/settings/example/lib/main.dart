// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_dart/fastyle_dart.dart' hide FastApp;
import 'package:go_router/go_router.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:lingua_core/lingua_core.dart';
import 'package:lingua_finance/generated/codegen_loader.g.dart';
import 'package:lingua_finance_instrument/generated/codegen_loader.g.dart';
import 'package:lingua_languages/generated/codegen_loader.g.dart';
import 'package:lingua_settings/generated/codegen_loader.g.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';

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
          SettingsCodegenLoader.mapLocales,
          LanguagesCodegenLoader.mapLocales,
          FinanceCodegenLoader.mapLocales,
          FinanceInstrumentCodegenLoader.mapLocales,
        ]),
      ),
    );
  }

  Widget buildHome(BuildContext context) {
    return FastSectionPage(
      titleText: 'Fastyle Settings',
      contentPadding: EdgeInsets.zero,
      showAppBar: false,
      child: FastNavigationListView(
        sortItems: false,
        items: [
          FastItem(
            labelText: CoreLocaleKeys.core_label_all.tr(
              gender: LinguaLocalizationGender.female,
            ),
            value: '/all',
          ),
          FastItem(
            labelText: SettingsLocaleKeys.settings_label_languages.tr(),
            value: '/languages',
          ),
          FastItem(
            labelText: SettingsLocaleKeys.settings_label_appearance.tr(),
            value: '/appearance',
          ),
          FastItem(
            labelText: SettingsLocaleKeys.settings_label_user_settings.tr(),
            value: '/user-settings',
          ),
          FastItem(
            labelText: SettingsLocaleKeys.settings_label_disclaimer.tr(),
            value: '/disclaimer',
          ),
          FastItem(
            labelText: SettingsLocaleKeys.settings_label_terms_of_service.tr(),
            value: '/tos',
          ),
          FastItem(
            labelText: SettingsLocaleKeys.settings_label_privacy_policy.tr(),
            value: '/privacy-policy',
          ),
        ],
        onSelectionChanged: (FastItem<String> item) {
          if (item.value != null) {
            GoRouter.of(context).go(item.value!);
          }
        },
      ),
    );
  }
}
