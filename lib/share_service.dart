import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import 'Utils/common.dart';

class ShareService {
  /// Share app link on social media platforms
  static Future<void> shareAppOnSocialMedia() async {
    const String appName = 'Ludo Game';
    final String packageName = Common.packageName;
    final String playStoreUrl =
        'https://play.google.com/store/apps/details?id=$packageName';

    final String shareText =
        '🎮 Check out this amazing Ludo Game! Download now: $playStoreUrl';

    try {
      await Share.share(
        shareText,
        subject: 'Download $appName',
      );
    } catch (e) {
      print('Error sharing app: $e');
    }
  }

  /// Share app on WhatsApp
  static Future<void> shareOnWhatsApp() async {
    await shareAppOnSocialMedia();
  }

  /// Share app on Facebook
  static Future<void> shareOnFacebook() async {
    await shareAppOnSocialMedia();
  }

  /// Share app on Twitter/X
  static Future<void> shareOnTwitter() async {
    final String packageName = Common.packageName;
    final String playStoreUrl =
        'https://play.google.com/store/apps/details?id=$packageName';
    final String message =
        '🎮 Check out this amazing Ludo Game! Download now: $playStoreUrl';

    final Uri twitterUrl = Uri.parse(
        'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(message)}');

    try {
      if (await canLaunchUrl(twitterUrl)) {
        await launchUrl(
          twitterUrl,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      print('Error opening Twitter: $e');
    }
  }

  /// Share app on Instagram (opens Instagram app)
  static Future<void> shareOnInstagram() async {
    final String packageName = Common.packageName;
    final String playStoreUrl =
        'https://play.google.com/store/apps/details?id=$packageName';

    // Instagram doesn't support direct URL sharing, so we'll open the app
    final Uri instagramUrl = Uri.parse('instagram://');

    try {
      if (await canLaunchUrl(instagramUrl)) {
        await launchUrl(instagramUrl);
        // Show a message to copy the link
        await Share.share(
          '🎮 Check out this amazing Ludo Game! Download now: $playStoreUrl',
          subject: 'Ludo Game',
        );
      } else {
        // Fallback to general sharing
        await shareAppOnSocialMedia();
      }
    } catch (e) {
      print('Error opening Instagram: $e');
      // Fallback to general sharing
      await shareAppOnSocialMedia();
    }
  }

  /// Share app on Telegram
  static Future<void> shareOnTelegram() async {
    final String packageName = Common.packageName;
    final String playStoreUrl =
        'https://play.google.com/store/apps/details?id=$packageName';
    final String message =
        '🎮 Check out this amazing Ludo Game! Download now: $playStoreUrl';

    final Uri telegramUrl = Uri.parse(
        'https://t.me/share/url?url=${Uri.encodeComponent(playStoreUrl)}&text=${Uri.encodeComponent(message)}');

    try {
      if (await canLaunchUrl(telegramUrl)) {
        await launchUrl(
          telegramUrl,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      print('Error opening Telegram: $e');
    }
  }

  /// Copy app link to clipboard
  static Future<void> copyAppLink() async {
    final String packageName = Common.packageName;
    final String playStoreUrl =
        'https://play.google.com/store/apps/details?id=$packageName';

    try {
      await Share.share(
        playStoreUrl,
        subject: 'Ludo Game Download Link',
      );
    } catch (e) {
      print('Error copying link: $e');
    }
  }
}
