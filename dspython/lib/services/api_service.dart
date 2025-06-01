import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
class ApiService {
  static final String baseUrl = "http://127.0.0.1:8000";


  // LOGIN avec Email
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login/');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}), // 🔥 envoie email
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access', data['access']);
      await prefs.setString('refresh', data['refresh']);
      await prefs.setString('user', jsonEncode(data['user']));
      return true;
    } else {
      return false;
    }
  }

  // LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access');
    await prefs.remove('refresh');
    await prefs.remove('user');
  }

  // GET DASHBOARD
  static Future<Map<String, dynamic>?> getDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    final access = prefs.getString('access');
    if (access == null) return null;

    final url = Uri.parse('$baseUrl/api/dashboard/');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $access",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  // SIGNUP
  static Future<bool> signup(String username, String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/register/');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      }),
    );

    return response.statusCode == 201; // 201 Created si l'inscription réussit
  }

  // Ajoute cette méthode dans ton fichier ApiService
  static Future<bool> resetPassword(String email, String newPassword) async {
    final url = Uri.parse('$baseUrl/api/auth/reset-password/');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "new_password": newPassword,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<Map<String, String>> getDeviceDetails() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return {
        'device_name': androidInfo.model ?? 'Android',
        'device_type': 'Mobile',
      };
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return {
        'device_name': iosInfo.utsname.machine ?? 'iPhone',
        'device_type': 'Mobile',
      };
    }
    else if (Platform.isWindows) {
      final windowsInfo = await deviceInfo.windowsInfo;
      return {
        'device_name': windowsInfo.computerName ?? 'Windows PC',
        'device_type': 'Desktop',
      };}
    return {
      'device_name': 'Unknown',
      'device_type': 'Other',
    };
  }


  static Future<void> createDeviceSession() async {
    final prefs = await SharedPreferences.getInstance();
    final access = prefs.getString('access');
    if (access == null) return;

    final details = await getDeviceDetails(); //

    final url = Uri.parse('$baseUrl/api/devices/create/');
    final expires = DateTime.now().add(Duration(days: 2));

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $access',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "device_name": details['device_name'],
        "device_type": details['device_type'],
        "expires_at": expires.toUtc().toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      print("✅ DeviceSession créée avec succès");
    } else {
      print("❌ Erreur DeviceSession: ${response.body}");
    }
  }


}
