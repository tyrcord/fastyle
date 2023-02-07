import 'package:fastyle_images/fastyle_images.dart';
import 'package:fastyle_images_example/pages/flags.page.dart';
import 'package:go_router/go_router.dart';

final kAppRoutes = [
  GoRoute(
    path: 'flags',
    builder: (context, state) => const FlagsPage(),
  ),
];
