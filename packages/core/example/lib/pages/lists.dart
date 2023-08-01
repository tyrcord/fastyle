import 'dart:developer';

import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';

class ListsPage extends StatelessWidget {
  const ListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      const FastItem(labelText: 'Option 1', value: 1),
      const FastItem(labelText: 'Option 2', value: 2),
      const FastItem(labelText: 'Option 3', value: 3),
    ];

    final optionWithDescriptions = [
      const FastItem(
        labelText: 'Option 1',
        value: 1,
        descriptionText: 'Description 1',
      ),
      const FastItem(
        labelText: 'Option 2',
        value: 2,
        descriptionText: 'Description 2',
      ),
      const FastItem(
        labelText: 'Option 3',
        value: 3,
        descriptionText: 'Description 3',
      ),
    ];

    return FastSectionPage(
      isViewScrollable: true,
      titleText: 'Lists',
      contentPadding: EdgeInsets.zero,
      child: Column(
        children: [
          const FastListHeader(
            categoryText: 'No Option selected',
          ),
          FastSelectableListView(
            isViewScrollable: false,
            items: options,
            onSelectionChanged: (FastItem option) {
              log('${option.labelText} selected');
            },
          ),
          const FastListHeader(
            categoryText: 'Default Option Selected',
            captionText: 'caption',
          ),
          FastSelectableListView(
            isViewScrollable: false,
            items: options,
            selection: options.first,
            onSelectionChanged: (FastItem option) {
              log('${option.labelText} selected');
            },
          ),
          const FastListHeader(
            categoryText: 'Options with descriptions',
          ),
          FastSelectableListView(
            isViewScrollable: false,
            items: optionWithDescriptions,
            selection: optionWithDescriptions[2],
            onSelectionChanged: (FastItem option) {
              log('${option.labelText} selected');
            },
          ),
          const FastListHeader(
            categoryText: 'Options with dividers',
          ),
          FastSelectableListView(
            showItemDivider: true,
            isViewScrollable: false,
            items: optionWithDescriptions,
            selection: optionWithDescriptions[2],
            onSelectionChanged: (FastItem option) {
              log('${option.labelText} selected');
            },
          ),
        ],
      ),
    );
  }
}
