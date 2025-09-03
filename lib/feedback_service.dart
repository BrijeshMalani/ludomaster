import 'package:url_launcher/url_launcher.dart';

import 'Utils/common.dart';

class FeedbackService {
  /// Opens Play Store feedback page for the app
  static Future<void> openPlayStoreFeedback() async {
    final String packageName = Common.packageName; // Your app's package name
    final String playStoreUrl =
        'https://play.google.com/store/apps/details?id=$packageName&showAllReviews=true';

    try {
      final Uri url = Uri.parse(playStoreUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback to general Play Store if specific URL fails
        const String fallbackUrl = 'https://play.google.com/store/apps';
        final Uri fallbackUri = Uri.parse(fallbackUrl);
        if (await canLaunchUrl(fallbackUri)) {
          await launchUrl(
            fallbackUri,
            mode: LaunchMode.externalApplication,
          );
        }
      }
    } catch (e) {
      print('Error opening Play Store: $e');
    }
  }

  /// Opens Play Store app page
  static Future<void> openPlayStoreAppPage() async {
    final String packageName = Common.packageName;
    final String playStoreUrl =
        'https://play.google.com/store/apps/details?id=$packageName';

    try {
      final Uri url = Uri.parse(playStoreUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      print('Error opening Play Store app page: $e');
    }
  }

  /// Opens email feedback
  static Future<void> openEmailFeedback() async {
    const String email =
        'support@yourcompany.com'; // Replace with your support email
    const String subject = 'Ludo Game Feedback';
    const String body =
        'Hi, I would like to provide feedback about the Ludo Game app.';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=$subject&body=$body',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      }
    } catch (e) {
      print('Error opening email: $e');
    }
  }
}
