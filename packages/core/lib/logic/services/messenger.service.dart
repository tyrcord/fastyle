// Package imports:
import 'package:tlogger/logger.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// A class representing a fast messenger.
class FastMessenger {
  static String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  static Future<bool> writeEmail(
    String recipientEmail, {
    String? subject,
    String? body,
  }) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      query: encodeQueryParameters(<String, String>{
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      }),
    );

    // Open the link directly: on iOS, canLaunchUrl needs the mailto scheme
    // declared in LSApplicationQueriesSchemes and fails without Apple Mail.
    try {
      return await launchUrlString(uri.toString());
    } catch (error) {
      return false;
    }
  }

  /// Longest log excerpt sent in a bug report; mail apps reject very long
  /// mailto links.
  static const _maxErrorLogLength = 4000;

  static Future<bool> writeErrorEmail(
    String recipientEmail, {
    String? subject,
    String? body,
  }) async {
    final logFile = await TLoggerJournal().getLogFile();
    final log = await logFile.readAsString();
    body = log;

    if (log.length > _maxErrorLogLength) {
      // Keep the most recent lines.
      final tail = log.substring(log.length - _maxErrorLogLength);
      final lineStart = tail.indexOf('\n');
      body = lineStart == -1 ? tail : tail.substring(lineStart + 1);
    }

    return writeEmail(recipientEmail, subject: subject, body: body);
  }

  /// Launches a URL using the provided URL string.
  static Future<void> launchUrl(
    String url, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: mode);
    } else {
      // TODO: handle errors
    }
  }
}
