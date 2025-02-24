import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AwUserService {
  Future<UserToken?> login(String userId) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/resident'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"customer_id": userId}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return UserToken.fromJson(jsonResponse['data']);
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return null;
  }

  Future<UserToken?> loginNewUser({required String type, required String phone, required String email, required String firstName, required String lastName}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/person'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "type": type,
        "phone": phone,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return UserToken.fromJson(jsonResponse['data']);
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<bool> submitConsents(String token, String consentId, Map<String, bool> consents) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/consent/submit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        "consent_id": consentId,
        "items": consents.entries
            .map((entry) => {
                  "item_id": entry.key,
                  "checked": entry.value,
                })
            .toList(),
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['status'] == 'success';
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return false;
  }

  static Future<bool> setPreferedLanguage(String token, String language) async {
    final response = await http
        .post(
          Uri.parse('$BASE_URL/mobile/setting/language'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, String>{"language": language}),
        )
        .timeout(const Duration(seconds: 5), onTimeout: () => http.Response('{"status": "error"}', 408));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return true;
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return false;
  }
}
