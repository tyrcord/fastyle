// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_dart/fastyle_dart.dart' hide FastApp;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:lingua_core/lingua_core.dart';
import 'package:lingua_finance/generated/codegen_loader.g.dart';
import 'package:lingua_finance_instrument/generated/codegen_loader.g.dart';
import 'package:lingua_languages/generated/codegen_loader.g.dart';
import 'package:lingua_settings/generated/codegen_loader.g.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';
import 'package:tbloc/tbloc.dart';
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
        ]),
      ),
    );
  }

  Widget buildHome(BuildContext context) {
    return FastAppInfoPage<String>(
      titleText: SettingsLocaleKeys.settings_label_app_settings.tr(),
      showAppBar: false,
      categoryDescriptors: [
        FastNavigationCategoryDescriptor(
          titleText: SettingsLocaleKeys.settings_label_app_settings.tr(),
          items: [
            FastItem(
              labelText: SettingsLocaleKeys.settings_label_appearance.tr(),
              value: '/appearance',
              descriptor: buildListItemDescriptor(
                context,
                icon: FontAwesomeIcons.palette,
              ),
            ),
            FastItem(
              labelText: SettingsLocaleKeys.settings_label_languages.tr(),
              value: '/languages',
              descriptor: buildListItemDescriptor(
                context,
                icon: FontAwesomeIcons.globe,
              ),
            ),
            FastItem(
              labelText: SettingsLocaleKeys.settings_label_user_settings.tr(),
              value: '/user-settings',
              descriptor: buildListItemDescriptor(
                context,
                icon: FontAwesomeIcons.solidCircleUser,
              ),
            ),
          ],
        ),
        FastNavigationCategoryDescriptor(
          titleText: SettingsLocaleKeys.settings_label_customer_support.tr(),
          items: [
            FastItem(
              labelText:
                  SettingsLocaleKeys.settings_label_help_and_support.tr(),
              value: 'contact-us',
              descriptor: buildListItemDescriptor(context,
                  icon: FontAwesomeIcons.lifeRing),
            ),
            FastItem(
              labelText:
                  SettingsLocaleKeys.settings_label_submit_bug_report.tr(),
              value: 'bug-report',
              descriptor: buildListItemDescriptor(
                context,
                icon: FontAwesomeIcons.bug,
              ),
            ),
          ],
        ),
        FastNavigationCategoryDescriptor(
          titleText: SettingsLocaleKeys.settings_label_legal.tr(),
          items: [
            FastItem(
              labelText: SettingsLocaleKeys.settings_label_privacy_policy.tr(),
              value: '/privacy-policy',
              descriptor: buildListItemDescriptor(
                context,
                icon: FontAwesomeIcons.userSecret,
              ),
            ),
            FastItem(
              labelText:
                  SettingsLocaleKeys.settings_label_terms_of_service.tr(),
              value: '/tos',
              descriptor: buildListItemDescriptor(
                context,
                icon: FontAwesomeIcons.fileContract,
              ),
            ),
            FastItem(
              labelText: SettingsLocaleKeys.settings_label_disclaimer.tr(),
              value: '/disclaimer',
              descriptor: buildListItemDescriptor(
                context,
                icon: FontAwesomeIcons.bullhorn,
              ),
            ),
          ],
        ),
        FastNavigationCategoryDescriptor(
          titleText: 'Fastyle',
          items: [
            FastItem(
              labelText: SettingsLocaleKeys.settings_label_rate_us.tr(),
              value: 'action://rate-us',
              descriptor: buildListItemDescriptor(
                context,
                icon: FontAwesomeIcons.thumbsUp,
              ),
            ),
            FastItem(
              labelText: CoreLocaleKeys.core_label_share_app.tr(),
              value: 'action://share',
              descriptor: buildListItemDescriptor(
                context,
                icon: FontAwesomeIcons.arrowUpRightFromSquare,
              ),
            ),
          ],
        ),
        FastNavigationCategoryDescriptor(
          titleText: CoreLocaleKeys.core_label_follow_us.tr(),
          items: [
            FastItem(
              labelText: CoreLocaleKeys.core_label_website.tr(),
              value: 'action://site',
              descriptor: buildListItemDescriptor(
                context,
                icon: FontAwesomeIcons.house,
              ),
            ),
            FastItem(
              labelText: 'Twitter',
              value: 'action://twitter',
              descriptor: buildListItemDescriptor(
                context,
                icon: FontAwesomeIcons.twitter,
              ),
            ),
            FastItem(
              labelText: 'Facebook',
              value: 'action://facebook',
              descriptor: buildListItemDescriptor(
                context,
                icon: FontAwesomeIcons.facebook,
              ),
            ),
          ],
        ),
      ],
      onNavigationItemTap: (FastItem<String> item) {
        if (item.value != null) {
          final value = item.value!;

          if (value.startsWith('action://')) {
            final action = value.replaceFirst('action://', '');
            final appInfoBloc = BlocProvider.of<FastAppInfoBloc>(context);
            final appInfo = appInfoBloc.currentState;

            switch (action) {
              case 'rate-us':
                final rateService = FusexAppRatingService(appInfo.toDocument());

                rateService.showAppRatingDialog(context);
              case 'share':
                FastShare.shareApp(context);
              case 'site':
                if (appInfo.homepageUrl != null) {
                  FastMessenger.launchUrl(appInfo.homepageUrl!);
                }
              case 'facebook':
                if (appInfo.facebookUrl != null) {
                  FastMessenger.launchUrl(appInfo.facebookUrl!);
                }
              default:
                debugPrint('Unknown action: $action');
                break;
            }
          } else {
            GoRouter.of(context).go(item.value!);
          }
        }
      },
    );
  }

  FastListItemDescriptor buildListItemDescriptor(
    BuildContext context, {
    required IconData icon,
  }) {
    final scaleFactor = MediaQuery.textScaleFactorOf(context);

    return FastListItemDescriptor(
      leading: FaIcon(
        icon,
        size: kFastIconSizeSmall * scaleFactor,
      ),
    );
  }
}
