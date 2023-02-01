import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FastApp(
      home: FastSectionPage(
        titleText: 'Fastyle Onboarding Demo',
        contentPadding: EdgeInsets.zero,
        showAppBar: false,
        child: FastNavigationListView(
          items: const [
            FastItem(labelText: 'Notifications', value: 'notifications'),
            FastItem(labelText: 'Personalized Ads', value: 'ads'),
          ],
          onSelectionChanged: (FastItem<dynamic> value) {},
        ),
      ),
    );
  }
}
