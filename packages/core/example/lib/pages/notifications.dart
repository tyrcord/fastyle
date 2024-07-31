// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      titleText: 'Notifications',
      isViewScrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FastRaisedButton2(
            labelText: 'info button',
            onTap: () {
              FastNotificationCenter.info(
                context,
                'info message',
                options: const FastNotificationCenterOptions(
                  leadingIcon: Icon(Icons.message),
                ),
              );
            },
          ),
          FastRaisedButton2(
            labelText: 'error button',
            onTap: () {
              FastNotificationCenter.error(
                context,
                'error message',
                options: const FastNotificationCenterOptions(
                  leadingIcon: Icon(Icons.bug_report),
                ),
              );
            },
          ),
          FastRaisedButton2(
            labelText: 'warn button',
            onTap: () {
              FastNotificationCenter.warn(
                context,
                'warn message',
              );
            },
          ),
          FastRaisedButton2(
            labelText: 'success button',
            onTap: () {
              FastNotificationCenter.success(
                context,
                'success message',
              );
            },
            shouldTrottleTime: true,
          ),
        ],
      ),
    );
  }
}
