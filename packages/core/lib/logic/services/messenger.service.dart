/// Import the required package for launching URLs.

// Package imports:
import 'package:url_launcher/url_launcher_string.dart';

/// A class representing a fast messenger.
class FastMessenger {
  static String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  static Future<void> writeEmail(
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

    return launchUrl(uri.toString());
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
