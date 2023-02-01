import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import './routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FastApp(
      routes: kAppRoutes,
      home: FastSectionPage(
        titleText: 'Fastyle Onboarding',
        contentPadding: EdgeInsets.zero,
        showAppBar: false,
        child: Builder(
          builder: (context) {
            return FastNavigationListView(
              items: const [
                FastItem(labelText: 'Notifications', value: 'notifications'),
                FastItem(labelText: 'Personalized Ads', value: 'ads'),
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
