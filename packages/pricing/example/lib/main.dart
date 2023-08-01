// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import './pages/plan_summary_cards.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FastApp(
      homeBuilder: (context) => const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
