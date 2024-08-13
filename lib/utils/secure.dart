import 'package:easyweather/utils/function.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const storage = FlutterSecureStorage();

Future<void> getTokenAndSave() async {
  var response = await http.get(Uri.parse('$api/generateToken'));
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    String token = jsonResponse['token'];
    await storage.write(key: 'auth_token', value: token);
  } else {
    print('Failed to get token');
  }
}

Future<void> storeToken(String token) async {
  await storage.write(key: 'auth_token', value: token);
}

Future<String?> getToken() async {
  return await storage.read(key: 'auth_token');
}
