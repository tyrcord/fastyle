import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';

import './pages/plan_summary_cards.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const FastApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      titleText: 'Fastyle Pricing Demo',
      contentPadding: EdgeInsets.zero,
      child: FastNavigationListView(
        onSelectionChanged: (FastItem<dynamic> item) {
          if (item.value == 'summary') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PlanSummaryCardsPage()),
            );
          }
        },
        items: const [
          FastItem(labelText: 'Plan Summary cards', value: 'summary'),
          FastItem(labelText: 'Plan Detail cards', value: 'detail'),
        ],
      ),
    );
  }
}
