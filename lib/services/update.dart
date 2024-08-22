import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:easyweather/services/notify.dart';

String currentVersion = "v1.1.4";

Future<void> checkForUpdates() async {
  final response = await http.get(Uri.parse(
      'https://api.github.com/repos/ClaretWheel1481/easyweather/releases/latest'));
  if (response.statusCode == 200) {
    final latestRelease = json.decode(response.body);
    final latestVersion = latestRelease['tag_name'];
    if (latestVersion != currentVersion) {
      final releaseUrl = latestRelease['html_url'];
      final Uri releaseUri = Uri.parse(releaseUrl);
      await launchUrl(releaseUri);
    } else {
      showNotification('检查更新', '当前已是最新版本！');
    }
  } else {
    showNotification('检查更新', '无法检查更新，请确保您可以正常访问Github！');
  }
}
