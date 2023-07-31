// Flutter imports:
import 'package:fastyle_dart/fastyle_dart.dart' hide FastApp;
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_iap/fastyle_iap.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lingua_core/lingua_core.dart';

import 'package:lingua_purchases/generated/codegen_loader.g.dart';
import 'package:tbloc/tbloc.dart';

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
      blocProviders: [
        BlocProvider(bloc: FastStoreBloc()),
      ],
      loaderJobs: [
        FastIapStoreJob(),
      ],
    );
  }

  Widget buildHome(BuildContext context) {
    return const FastIapPremiumPage(
      premiumProductId: 'com.fastyle.premium',
      items: [
        FastItem(
          labelText: 'No ads',
          descriptor: FastListItemDescriptor(
            leading: FaIcon(FontAwesomeIcons.bullhorn),
          ),
        ),
        FastItem(
          labelText: 'Unlimited access',
          descriptor: FastListItemDescriptor(
            leading: FaIcon(FontAwesomeIcons.lockOpen),
          ),
        ),
        FastItem(
          labelText: 'Better experience',
          descriptor: FastListItemDescriptor(
            leading: FaIcon(FontAwesomeIcons.faceSmile),
          ),
        ),
        FastItem(
          labelText: 'More features',
          descriptor: FastListItemDescriptor(
            leading: FaIcon(FontAwesomeIcons.rocket),
          ),
        ),
        FastItem(
          labelText: 'No tracking',
          descriptor: FastListItemDescriptor(
            leading: FaIcon(FontAwesomeIcons.userShield),
          ),
        ),
        FastItem(
          labelText: 'And more...',
          descriptor: FastListItemDescriptor(
            leading: FaIcon(FontAwesomeIcons.ellipsis),
          ),
        ),
      ],
    );
  }
}
