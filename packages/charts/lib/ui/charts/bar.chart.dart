// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_charts/fastyle_charts.dart';

class BarChart extends StatelessWidget {
  final List<FastChartData> data;
  final double separatorWidth;
  final double separatorPadding;
  final Color? seperatorColor;
  final double barHeight;
  final double barPadding;
  final Color? labelsBackgroundColor;
  final Color? chartBackgroundColor;

  double get barItemHeight => barHeight + barPadding * 2;

  const BarChart({
    super.key,
    required this.data,
    this.separatorWidth = 6.0,
    this.separatorPadding = 8.0,
    this.seperatorColor,
    this.barHeight = 8.0,
    this.barPadding = 6.0,
    this.labelsBackgroundColor,
    this.chartBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildLabels(),
        Expanded(
          child: Stack(
            children: [
              _buildChart(),
              buildSeparatorLine(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: separatorPadding),
      color: chartBackgroundColor,
      child: Column(
        children: data.map((item) => _buildBar(item)).toList(),
      ),
    );
  }

  Widget _buildLabels() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: separatorPadding),
      color: labelsBackgroundColor,
      child: Column(
        children: data
            .where((datum) => datum.label != null && datum.label!.isNotEmpty)
            .map((item) => _buildLabel(item))
            .toList(),
      ),
    );
  }

  Widget _buildLabel(FastChartData item) {
    return SizedBox(
      height: barItemHeight,
      child: Center(
        child: Text(
          item.label!,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget buildSeparatorLine() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: (barItemHeight) * data.length + separatorPadding * 2,
          width: separatorWidth,
          decoration: BoxDecoration(
            color: seperatorColor ?? Colors.grey[300],
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(6.0),
              right: Radius.circular(6.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBar(FastChartData item) {
    return Row(
      children: [
        Expanded(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: _buildNegativeBar(item),
          ),
        ),
        SizedBox(width: separatorWidth),
        Expanded(child: _buildPositiveBar(item)),
      ],
    );
  }

  Widget _buildPositiveBar(FastChartData item) {
    if (item.value > 0) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: barPadding),
        child: Row(
          children: [
            Container(
              width: item.value.abs(),
              height: barHeight,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(barHeight / 2),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        item.value.toString(),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 11.0,
        ),
      ),
    );
  }

  Widget _buildNegativeBar(FastChartData item) {
    if (item.value < 0) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: barPadding),
        child: Row(
          children: <Widget>[
            Container(
              width: item.value.abs(),
              height: barHeight,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(barHeight / 2),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(right: 4),
      child: Text(
        '+${item.value.toString()}',
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 10.0,
        ),
      ),
    );
  }
}
