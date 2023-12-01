// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_charts/fastyle_charts.dart';

class FastChartLegend extends StatelessWidget {
  final List<FastChartData> data;
  final bool isHorizontal;
  final bool showPercentage;

  const FastChartLegend({
    super.key,
    required this.data,
    this.isHorizontal = false,
    bool? showPercentage = false,
  }) : showPercentage = showPercentage ?? false;

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return Wrap(
        runSpacing: 16,
        spacing: 16,
        children: _buildChildren(),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      );
    }
  }

  List<Widget> _buildChildren() {
    return data
        .where((datum) => datum.label != null && datum.label!.isNotEmpty)
        .map((datum) {
      return Padding(
        padding: kFastVerticalEdgeInsets6,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 6,
          spacing: 12,
          children: <Widget>[
            FastShadowLayout(
              child: Container(width: 16, height: 16, color: datum.color),
            ),
            FastBody(
              text: datum.label!,
              fontSize: kFastFontSize16,
            ),
            if (showPercentage) ...[
              FastSecondaryBody(
                text: '(${formatPercentage(value: datum.value)})',
                fontSize: kFastFontSize14,
              ),
            ],
          ],
        ),
      );
    }).toList();
  }
}
