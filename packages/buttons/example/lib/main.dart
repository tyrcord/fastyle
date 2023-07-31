// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:fastyle_core/fastyle_core.dart';

final kAppInfo = kFastAppInfo.copyWith(
  appName: 'Fastyle Buttons',
  databaseVersion: 0,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isPending = false;

  @override
  Widget build(BuildContext context) {
    return FastApp(
      appInformation: kAppInfo,
      homeBuilder: (context) => buildHome(context),
    );
  }

  Widget buildHome(BuildContext context) {
    return FastSectionPage(
      titleText: 'Buttons',
      showAppBar: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FastCopyButton(valueText: '42'),
          FastPendingOutlineButton(
            text: 'Outline button',
            onTap: () {
              setState(() => _isPending = !_isPending);
            },
            isPending: _isPending,
          ),
          FastPendingRaisedButton(
            text: 'Raised button',
            onTap: () {
              setState(() => _isPending = !_isPending);
            },
            isPending: _isPending,
          ),
        ],
      ),
    );
  }
}
