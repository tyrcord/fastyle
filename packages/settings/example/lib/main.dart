// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_pricing/fastyle_pricing.dart';
import 'package:fastyle_settings/fastyle_settings.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:lingua_core/lingua_core.dart';
import 'package:lingua_finance/generated/codegen_loader.g.dart';
import 'package:lingua_finance_instrument/generated/codegen_loader.g.dart';
import 'package:lingua_languages/generated/codegen_loader.g.dart';
import 'package:lingua_purchases/generated/codegen_loader.g.dart';
import 'package:lingua_settings/generated/codegen_loader.g.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';
import 'package:lingua_share/generated/codegen_loader.g.dart';

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
          ShareCodegenLoader.mapLocales,
          PurchasesCodegenLoader.mapLocales,
        ]),
      ),
    );
  }

  Widget buildHome(BuildContext context) {
    return FastAppInfoPage<String>(
      titleText: SettingsLocaleKeys.settings_label_app_settings.tr(),
      showAppBar: false,
      header: FastPremiumSettingsHeader(
        onGoPremium: () {
          debugPrint('Go premium');
        },
      ),
      categoryDescriptors: [
        FastNavigationCategoryDescriptor(
          titleText: SettingsLocaleKeys.settings_label_app_settings.tr(),
          items: [
            FastSettingsItem.getItem(context, FastSettingsItems.appearance),
            FastSettingsItem.getItem(context, FastSettingsItems.language),
            FastSettingsItem.getItem(context, FastSettingsItems.calculator),
          ],
        ),
        FastNavigationCategoryDescriptor(
          titleText: SettingsLocaleKeys.settings_label_customer_support.tr(),
          items: [
            FastSettingsItem.getItem(context, FastSettingsItems.contactUs),
            FastSettingsItem.getItem(context, FastSettingsItems.bugReport),
          ],
        ),
        FastNavigationCategoryDescriptor(
          titleText: SettingsLocaleKeys.settings_label_legal.tr(),
          items: [
            FastSettingsItem.getItem(context, FastSettingsItems.privacyPolicy),
            FastSettingsItem.getItem(context, FastSettingsItems.termsOfService),
            FastSettingsItem.getItem(context, FastSettingsItems.disclaimer),
          ],
        ),
        FastNavigationCategoryDescriptor(
          titleText: 'Fastyle',
          items: [
            FastSettingsItem.getItem(context, FastSettingsItems.share),
            FastSettingsItem.getItem(context, FastSettingsItems.rateUs),
          ],
        ),
        FastNavigationCategoryDescriptor(
          titleText: CoreLocaleKeys.core_label_follow_us.tr(),
          items: [
            FastSettingsItem.getItem(context, FastSettingsItems.website),
            FastSettingsItem.getItem(context, FastSettingsItems.twitter),
            FastSettingsItem.getItem(context, FastSettingsItems.facebook),
          ],
        ),
      ],
    );
  }
}
