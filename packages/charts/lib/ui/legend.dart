import 'package:flutter/material.dart';
import 'package:fastyle_charts/fastyle_charts.dart';
import 'package:fastyle_core/fastyle_core.dart';

class FastChartLegend extends StatelessWidget {
  final List<FastChartData> data;

  const FastChartLegend({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: data.map((datum) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(width: 20, height: 20, color: datum.color),
            kFastHorizontalSizedBox24,
            Text(datum.label),
          ],
        );
      }).toList(),
    );
  }
}
