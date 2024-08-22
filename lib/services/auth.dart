import 'package:easyweather/services/notify.dart';
import 'package:easyweather/services/weather.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const storage = FlutterSecureStorage();

Future<void> getTokenAndSave() async {
  try {
    var response = await http.get(Uri.parse('$api/generateToken'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      String token = jsonResponse['token'];
      await storage.write(key: 'auth_token', value: token);
    }
  } catch (e) {
    showNotification("错误", "无法获取Token，请检查您的网络设置，并重新启动EasyWeather。");
    return;
  }
}

Future<void> storeToken(String token) async {
  await storage.write(key: 'auth_token', value: token);
}

Future<String?> getToken() async {
  return await storage.read(key: 'auth_token');
}
