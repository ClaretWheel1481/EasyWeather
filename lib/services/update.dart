import 'package:easyweather/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:easyweather/services/notify.dart';

Future<void> checkForUpdates() async {
  showNotification('检查更新', '正在查找最新版本信息...');
  try {
    final response = await http.get(Uri.parse(
        'https://api.github.com/repos/ClaretWheel1481/easyweather/releases/latest'));
    final latestRelease = json.decode(response.body);
    final latestVersion = latestRelease['tag_name'];

    if (latestVersion != AppConstants.currentVersion) {
      final releaseUrl = latestRelease['html_url'];
      final Uri releaseUri = Uri.parse(releaseUrl);
      await launchUrl(releaseUri);
    } else {
      showNotification('检查更新', '当前已是最新版本！');
    }
  } catch (e) {
    showNotification('检查更新', '检查更新错误，请确保您可以正常访问Github！');
  }
}
