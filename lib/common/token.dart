// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isTokenAvailable() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");
  if (token == null) {
    return false;
  }
  return true;
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");

  return token;
}

Future<void> deleteToken() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("token");
}

void saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("token", token);
}
