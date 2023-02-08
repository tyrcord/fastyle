import 'package:fastyle_images_example/pages/commodities.page.dart';
import 'package:fastyle_images_example/pages/cryptos.page.dart';
import 'package:fastyle_images_example/pages/flags.page.dart';
import 'package:go_router/go_router.dart';

final kAppRoutes = [
  GoRoute(
    path: 'commodities',
    builder: (context, state) => const CommoditiesPage(),
  ),
  GoRoute(
    path: 'cryptos',
    builder: (context, state) => const CryptosPage(),
  ),
  GoRoute(
    path: 'flags',
    builder: (context, state) => const FlagsPage(),
  ),
];
