import 'package:easyweather/services/notify.dart';
import 'package:easyweather/services/weather.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const storage = FlutterSecureStorage();

Future<void> getTokenAndSave() async {
  String? existingToken = await storage.read(key: 'auth_token');
  if (existingToken != null) {
    return;
  }
  var response = await http.get(Uri.parse('$api/generateToken'));
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    String token = jsonResponse['token'];
    await storage.write(key: 'auth_token', value: token);
    showNotification("通知", "Token获取并保存成功！");
  } else {
    showNotification("错误", "未能获取到Token，您或许需要重新启动应用，否则无法使用该应用。");
    return;
  }
}

Future<void> storeToken(String token) async {
  await storage.write(key: 'auth_token', value: token);
}

Future<String?> getToken() async {
  return await storage.read(key: 'auth_token');
}
