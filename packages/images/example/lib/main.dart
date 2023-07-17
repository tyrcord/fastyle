import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import './routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
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
        titleText: 'Fastyle Images',
        contentPadding: EdgeInsets.zero,
        showAppBar: false,
        child: Builder(
          builder: (context) {
            return FastNavigationListView(
              items: const [
                FastItem(
                  labelText: 'commodities',
                  value: '/commodities',
                ),
                FastItem(
                  labelText: 'cryptos',
                  value: '/cryptos',
                ),
                FastItem(
                  labelText: 'flags',
                  value: '/flags',
                ),
              ],
              onSelectionChanged: (FastItem<String> item) {
                if (item.value == null) {
                  GoRouter.of(context).go(item.value!);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
