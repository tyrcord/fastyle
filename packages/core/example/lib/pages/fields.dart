//ignore_for_file: no-empty-block

// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import 'package:fastyle_core_example/data/items.dart';

class FieldsPage extends StatelessWidget {
  const FieldsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return FastSectionPage(
      titleText: 'Fields',
      isViewScrollable: true,
      child: Column(
        children: [
          FastListHeader(
            categoryText: 'category 1',
            categoryColor: primaryColor,
            padding: EdgeInsets.zero,
            margin: const EdgeInsets.only(bottom: 16.0),
          ),
          const FastNumberField(
            labelText: 'Number 1',
            placeholderText: '0',
            captionText: 'required',
          ),
          const FastTextField(
            labelText: 'Text 1',
            helperText: 'Do you need some help?',
          ),
          const FastNumberField(
            labelText: 'Number 2',
            placeholderText: '1000',
            captionText: 'optional',
          ),
          FastSegmentField(
            labelText: 'Position',
            options: const [
              FastItem(
                labelText: 'Long',
                value: 'long',
              ),
              FastItem(
                labelText: 'Short',
                value: 'short',
              ),
            ],
            onValueChanged: (option) {
              log(option.value.toString());
            },
          ),
          const FastNumberField(
            labelText: 'Number 3',
            placeholderText: '42',
            captionText: 'optional',
          ),
          FastNumberField(
            labelText: 'Number with a suffix icon',
            placeholderText: '0',
            suffixIcon: FastPopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: Text('Option 1'),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text('Option 2'),
                ),
              ],
              padding: EdgeInsets.zero,
              icon: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.more_vert,
                  size: kFastIconSizeSmall,
                  color: ThemeHelper.texts.getBodyTextStyle(context).color,
                ),
              ),
            ),
          ),
          FastListHeader(
            categoryText: 'category 2',
            categoryColor: primaryColor,
            padding: EdgeInsets.zero,
            margin: const EdgeInsets.only(bottom: 16.0),
          ),
          FastNumberField(
            labelText: 'Number 3',
            placeholderText: '100',
            captionText: 'required',
            onValueChanged: (String value) => log('Length: ${value.length}'),
          ),
          FastNumberField(
            labelText: 'Number 4 (allow invalid number)',
            placeholderText: '0',
            captionText: 'required',
            transformInvalidNumber: false,
            onValueChanged: (String value) => log(value),
          ),
          FastNumberField(
            labelText: 'Number 5 (debounced)',
            placeholderText: '0',
            captionText: 'required',
            onValueChanged: (String value) => log('Length: ${value.length}'),
            shouldDebounceTime: true,
          ),
          FastSelectField(
            labelText: 'Favorite food',
            items: demoItems,
            groupByCategory: true,
            selection: demoItems[3],
            categories: demoCategories,
            onSelectionChanged: (FastItem<String>? value) {},
          ),
          FastNumberField(
            labelText: 'Number 5 (disabled)',
            placeholderText: '0',
            captionText: 'required',
            onValueChanged: (String value) => log(value),
            isEnabled: false,
          ),
          FastSelectField(
            labelText: 'Favorite food (disabled)',
            items: demoItems,
            groupByCategory: true,
            selection: demoItems[3],
            categories: demoCategories,
            onSelectionChanged: (FastItem<String>? value) {},
            isEnabled: false,
          ),
          const FastTextField(
            labelText: 'Text 2',
            placeholderText: 'value',
            captionText: 'optional',
          ),
          const FastReadOnlyTextField(
            labelText: 'Read Only',
            valueText: 'Can select text',
          ),
          const FastPendingReadOnlyTextField(
            labelText: 'Pending Read Only',
            valueText: 'Pending',
            pendingText: '\$0.000',
          ),
        ],
      ),
    );
  }
}
