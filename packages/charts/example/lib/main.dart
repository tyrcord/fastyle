// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_charts/fastyle_charts.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final data = <FastChartData>[
      FastChartData(label: 'Item 1', value: 80),
      FastChartData(label: 'Item 2', value: -20),
      FastChartData(label: 'Item 3', value: 40),
      FastChartData(label: 'Item 4', value: -60),
    ];

    return FastApp(
      lightTheme: FastTheme.light.blue,
      darkTheme: FastTheme.dark.blue,
      routesForMediaType: (mediaType) => [
        GoRoute(
          path: '/',
          builder: (_, __) {
            final palettes = ThemeHelper.getPaletteColors(context);

            final pieData = [
              FastChartData(
                value: 0.12,
                color: palettes.blue.lighter,
                label: 'Blue',
              ),
              FastChartData(
                value: 0.12,
                color: kFastChartTealColor,
                label: 'Teal',
              ),
              FastChartData(
                value: 0.15,
                color: kFastChartMintColor,
                label: 'Mint',
              ),
              FastChartData(
                value: 0.05,
                color: kFastChartIndigoColor,
                label: 'Indigo',
              ),
              FastChartData(
                value: 0.30,
                color: kFastChartPurpleColor,
                label: 'Purple',
              ),
              FastChartData(
                value: 0.26,
                color: kFastChartBlueGrayColor,
                label: 'Blue Gray',
              ),
            ];

            return FastSectionPage(
              isViewScrollable: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const FastTitle(text: 'Bar Chart'),
                  kFastVerticalSizedBox24,
                  FractionallySizedBox(
                    widthFactor: 0.35,
                    alignment: FractionalOffset.center,
                    child: BarChart(data: data),
                  ),
                  kFastVerticalSizedBox24,
                  const FastTitle(text: 'Pie Chart'),
                  kFastVerticalSizedBox24,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FastPieChart(data: pieData, animate: true),
                      kFastHorizontalSizedBox48,
                      FastChartLegend(data: pieData),
                    ],
                  ),
                  kFastVerticalSizedBox24,
                  const FastTitle(text: 'Doughnut Chart'),
                  kFastVerticalSizedBox24,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FastDoughnutChart(data: pieData, animate: true),
                      kFastHorizontalSizedBox48,
                      FastChartLegend(data: pieData),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
