import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_core_example/data/items.dart';
import 'package:flutter/material.dart';

class SplitViewPage extends StatelessWidget {
  const SplitViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      contentPadding: EdgeInsets.zero,
      child: FastNavigationSplitView(
        detailsBuilder: (BuildContext context, FastItem item) {
          return Center(
            child: FastBody(
              text: item.labelText,
            ),
          );
        },
        items: demoItems,
      ),
    );
  }
}
