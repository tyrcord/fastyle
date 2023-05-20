import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_dart/ui/ui.dart';
import 'package:flutter/material.dart';

import './pages/plan_summary_cards.page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FastApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

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
              MaterialPageRoute(builder: (context) => PlanSummaryCardsPage()),
            );
          }
        },
        items: [
          FastItem(labelText: 'Plan Summary cards', value: 'summary'),
          FastItem(labelText: 'Plan Detail cards', value: 'detail'),
        ],
      ),
    );
  }
}
