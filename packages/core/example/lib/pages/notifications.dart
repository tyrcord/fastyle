import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';

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
          FastRaisedButton(
            text: 'info button',
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
          FastRaisedButton(
            text: 'error button',
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
          FastRaisedButton(
            text: 'warn button',
            onTap: () {
              FastNotificationCenter.warn(
                context,
                'warn message',
              );
            },
          ),
          FastRaisedButton(
            text: 'success button',
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
