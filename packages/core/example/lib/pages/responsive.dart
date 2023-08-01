import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FastMediaLayoutBuilder(builder: ((context, mediaType) {
      Widget content;

      if (mediaType <= FastMediaType.tablet) {
        content = buildColumnView(context, mediaType);
      } else {
        content = buildGridView(context, mediaType);
      }

      return FastSectionPage(
        titleText: 'Responsive (${mediaType.name})',
        isViewScrollable: true,
        child: Container(child: content),
      );
    }));
  }

  Widget buildColumnView(BuildContext context, FastMediaType mediaType) {
    return Column(
      children: buildBoxes(context, true),
    );
  }

  Widget buildGridView(BuildContext context, FastMediaType mediaType) {
    final spacing = ThemeHelper.spacing.getSpacing(context);
    final size = MediaQuery.sizeOf(context);
    final columnCount = mediaType.index;
    final double itemHeight = (size.height - kToolbarHeight) / columnCount;
    final double itemWidth = size.width / columnCount;

    return GridView.count(
      crossAxisCount: mediaType.index,
      childAspectRatio: (itemWidth / itemHeight),
      shrinkWrap: true,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      padding: const EdgeInsets.all(0),
      children: buildBoxes(context, false),
    );
  }

  List<Widget> buildBoxes(BuildContext context, bool hasSpacing) {
    var count = List<int>.filled(50, 0);
    var i = 0;

    return count.map((e) {
      return buildBox(context, ++i, hasSpacing);
    }).toList();
  }

  Widget buildBox(BuildContext context, int index, bool hasSpacing) {
    final palette = ThemeHelper.getPaletteColors(context);
    final spacing = hasSpacing ? ThemeHelper.spacing.getSpacing(context) : 0.0;

    return Container(
      color: palette.blue.mid,
      height: 64,
      margin: EdgeInsets.only(bottom: spacing),
      child: Center(
        child: FastBody(text: index.toString()),
      ),
    );
  }
}
