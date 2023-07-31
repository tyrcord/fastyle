// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_images/fastyle_images.dart';

class FlagsPage extends StatelessWidget {
  const FlagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      contentPadding: EdgeInsets.zero,
      isViewScrollable: true,
      titleText: 'Flags',
      child: FastListView(
        items: kFastImageFlag.map((name) {
          return FastItem(
            labelText: name,
            value: name,
            descriptor: FastListItemDescriptor(
              leading: FastImageAsset(
                path: kFastImageFlagMap[name]!,
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
