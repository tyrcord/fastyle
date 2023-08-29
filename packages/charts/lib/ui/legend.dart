import 'package:flutter/material.dart';
import 'package:fastyle_charts/fastyle_charts.dart';
import 'package:fastyle_core/fastyle_core.dart';

class FastChartLegend extends StatelessWidget {
  final List<FastChartData> data;
  final bool isHorizontal; // New parameter to control orientation

  const FastChartLegend({
    super.key,
    required this.data,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return Wrap(
        children: _buildChildren(),
        runSpacing: 16,
        spacing: 16,
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
    return data.map((datum) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FastShadowLayout(
            child: Container(width: 20, height: 20, color: datum.color),
          ),
          kFastHorizontalSizedBox16,
          Text(datum.label),
        ],
      );
    }).toList();
  }
}
