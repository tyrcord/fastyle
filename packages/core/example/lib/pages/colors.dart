// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

class ColorsPage extends StatelessWidget {
  const ColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return FastSectionPage(
      titleText: 'Colors',
      isViewScrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildScheme(context, 'Gray', palette.gray),
          buildScheme(context, 'Blue', palette.blue),
          buildScheme(context, 'Blue Gray', palette.blueGray),
          buildScheme(context, 'Teal', palette.teal),
          buildScheme(context, 'Indigo', palette.indigo),
          buildScheme(context, 'Purple', palette.purple),
          buildScheme(context, 'Mint', palette.mint),
          buildScheme(context, 'Green', palette.green),
          buildScheme(context, 'Pink', palette.pink),
          buildScheme(context, 'Red', palette.red),
          buildScheme(context, 'Orange', palette.orange),
          buildScheme(context, 'Yellow', palette.yellow),
          buildScheme(context, 'Brown', palette.brown),
        ],
      ),
    );
  }

  Widget buildScheme(
      BuildContext context, String title, FastPaletteScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FastTitle(text: title),
        kFastSizedBox16,
        buildColors(context, scheme),
        kFastSizedBox32,
      ],
    );
  }

  Widget buildColors(BuildContext context, FastPaletteScheme scheme) {
    final spacing = ThemeHelper.spacing.getSpacing(context);

    return Wrap(
      runSpacing: spacing,
      spacing: spacing,
      children: [
        buildColor('Lightest', scheme.lightest),
        buildColor('Lighter', scheme.lighter),
        buildColor('Light', scheme.light),
        buildColor('Mid', scheme.mid),
        buildColor('Dark', scheme.dark),
        buildColor('Darker', scheme.darker),
        buildColor('Darkest', scheme.darkest),
      ],
    );
  }

  Widget buildColor(String title, Color color) {
    return Container(
      constraints: const BoxConstraints(minWidth: 54),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FastSubtitle(
            text: title,
            fontSize: 13,
          ),
          kFastSizedBox8,
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: color,
            ),
            width: 40,
            height: 40,
          ),
          kFastSizedBox32,
          const FastBody(
            text: 'Hex:',
            fontSize: 14,
          ),
          FastSecondaryBody(
            text: _toHex(color),
            fontSize: 13,
            enableInteractiveSelection: true,
          ),
          kFastSizedBox8,
          FastBody(
            text: 'Sample',
            fontSize: 14,
            textColor: color,
          ),
        ],
      ),
    );
  }

  String _toHex(Color color, {bool showSign = true, bool showAlpha = false}) {
    return '${showSign ? '#' : ''}'
        '${showAlpha ? _toRadixString(color.alpha) : ''}'
        '${_toRadixString(color.red)}'
        '${_toRadixString(color.green)}'
        '${_toRadixString(color.blue)}';
  }

  String _toRadixString(int number) {
    return number.toRadixString(16).toUpperCase().padLeft(2, '0');
  }
}
