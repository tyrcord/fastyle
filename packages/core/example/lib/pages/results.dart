// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return const FastSectionPage(
      titleText: 'Results',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FastTitle(text: 'Progress Bars'),
          kFastSizedBox32,
          FastErrorResult(
            text: 'An error occurred',
          ),
          kFastSizedBox32,
          FastWarningResult(
            text: 'A warning occurred',
          ),
        ],
      ),
    );
  }
}
