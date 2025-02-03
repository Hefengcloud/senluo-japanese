import 'package:url_launcher/url_launcher.dart' as url_lancher;

class UrlHelper {
  static Future<void> launchUrl(String url) async {
    if (!await url_lancher.launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
