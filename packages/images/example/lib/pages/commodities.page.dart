// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_images/fastyle_images.dart';

class CommoditiesPage extends StatelessWidget {
  const CommoditiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      contentPadding: EdgeInsets.zero,
      isViewScrollable: true,
      titleText: 'Commodities',
      child: FastListView(
        items: kFastImageCommodity.map((name) {
          return FastItem(
            labelText: name,
            value: name,
            descriptor: FastListItemDescriptor(
              leading: FastImageAsset(
                path: kFastImageCommodityMap[name]!,
                width: 32,
                height: 32,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
