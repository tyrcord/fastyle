/// Import the required package for launching URLs.
import 'package:url_launcher/url_launcher_string.dart';

/// A class representing a fast messenger.
class FastMessenger {
  /// Asks for support by launching an email client with the provided
  /// support email.
  static void askForSupport(String email) async {
    final Uri uri = Uri(scheme: 'mailto', path: email);
    await launchUrl(uri.toString());
  }

  /// Reports a bug by launching an email client with the provided
  /// bug report email.
  static void reportBug(String email) async {
    final Uri uri = Uri(scheme: 'mailto', path: email);
    await launchUrl(uri.toString());
  }

  /// Launches a URL using the provided URL string.
  static Future<void> launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      // TODO: handle errors
    }
  }
}
