import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_register_service.dart';
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
        return null;
      }
    }
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
        return false;
      }
    } else {
      return false;
    }
  }
}
