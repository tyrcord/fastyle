import 'dart:developer';

import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final options = List<FastItem>.generate(50, (int index) {
      return FastItem(labelText: index.toString(), value: index);
    });

    return FastSectionPage(
      titleText: 'Tabs',
      contentPadding: EdgeInsets.zero,
      child: FastTabs(
        tabs: const [
          Tab(text: 'Favorites'),
          Tab(text: 'All'),
          Tab(text: 'Forex'),
          Tab(text: 'Commodoties'),
          Tab(text: 'Cryptocurrencies'),
          Tab(text: 'Stocks'),
        ],
        views: <Widget>[
          const Icon(Icons.favorite),
          FastSelectableListView(
            showItemDivider: true,
            items: options,
            sortItems: false,
            onSelectionChanged: (FastItem option) {
              log('${option.labelText} selected');
            },
          ),
          const Icon(Icons.euro_symbol),
          const Icon(Icons.donut_small),
          const Icon(Icons.attach_money),
          const Icon(Icons.home),
        ],
      ),
    );
  }
}
