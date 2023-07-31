import 'dart:developer';

import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';

class ListsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final options = [
      FastItem(labelText: 'Option 1', value: 1),
      FastItem(labelText: 'Option 2', value: 2),
      FastItem(labelText: 'Option 3', value: 3),
    ];

    final optionWithDescriptions = [
      FastItem(
        labelText: 'Option 1',
        value: 1,
        descriptionText: 'Description 1',
      ),
      FastItem(
        labelText: 'Option 2',
        value: 2,
        descriptionText: 'Description 2',
      ),
      FastItem(
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
          FastListHeader(
            categoryText: 'No Option selected',
          ),
          FastSelectableListView(
            isViewScrollable: false,
            items: options,
            onSelectionChanged: (FastItem option) {
              log('${option.labelText} selected');
            },
          ),
          FastListHeader(
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
          FastListHeader(
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
          FastListHeader(
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
