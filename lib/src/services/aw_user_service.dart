import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_header_util.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AwUserService {
  Future<UserToken?> login(String userId) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/resident'),
      headers: getPostHeader(),
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
      headers: getPostHeader(),
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
    final body = {
      "consent_id": consentId,
      "items": consents.entries
          .map((entry) => {
                "item_id": entry.key,
                "checked": entry.value,
              })
          .toList(),
    };
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/consent/submit'),
      headers: getPostHeader(token: token),
      body: jsonEncode(body),
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
          headers: getPostHeader(token: token),
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

  static Future<bool> updateFCMToken(String userToken, String fcmToken) async {
    final response = await http
        .post(
          Uri.parse('$BASE_URL/auth/fcm'),
          headers: getPostHeader(token: userToken),
          body: jsonEncode(<String, String>{"token": fcmToken}),
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

  static Future<bool> changeEmail(String userToken, String newValue) async {
    final response = await http
        .post(
          Uri.parse('$BASE_URL/mobile/setting/change-email'),
          headers: getPostHeader(token: userToken),
          body: jsonEncode(<String, String>{"email": newValue}),
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

  static Future<bool> changePhone(String userToken, String newValue) async {
    final response = await http
        .post(
          Uri.parse('$BASE_URL/mobile/setting/change-phone'),
          headers: getPostHeader(token: userToken),
          body: jsonEncode(<String, String>{"phone": newValue}),
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

  static Future<UserInformation?> getUserInformation(String userToken) async {
    final response = await http
        .get(
          Uri.parse('$BASE_URL/mobile/home/me'),
          headers: getHeader(token: userToken),
        )
        .timeout(const Duration(seconds: 5), onTimeout: () => http.Response('{"status": "error"}', 408));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return UserInformation.fromJson(jsonResponse['data']);
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<List<PersonalConsent>> fetchPersonalConsents(String userToken, {String? language}) async {
    final response = await http
        .get(
          Uri.parse('$BASE_URL/mobile/setting/consent'),
          headers: getHeader(token: userToken),
        )
        .timeout(const Duration(seconds: 5), onTimeout: () => http.Response('{"status": "error"}', 408));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          var consentsList = jsonResponse['data'] as List;
          return consentsList.map((i) => PersonalConsent.fromJson(i)).toList();
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return [];
  }

  static Future<PersonalConsentDetail?> fetchPersonalConsentDetail(String userToken, String consentId, {String? language}) async {
    final response = await http
        .get(
          Uri.parse('$BASE_URL/mobile/setting/consent/$consentId'),
          headers: getHeader(token: userToken),
        )
        .timeout(const Duration(seconds: 5), onTimeout: () => http.Response('{"status": "error"}', 408));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return PersonalConsentDetail.fromJson(jsonResponse['data']);
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<bool> submitPersonalConsent(String userToken, String consentId, bool consentGiven) async {
    final response = await http
        .post(
          Uri.parse('$BASE_URL/mobile/setting/consent/$consentId'),
          headers: getPostHeader(token: userToken),
          body: jsonEncode({
            "is_given": consentGiven,
          }),
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

  static Future<List<AboutItem>> fetchAboutItems(String userToken, {String? language}) async {
    final response = await http
        .get(
          Uri.parse('$BASE_URL/mobile/setting/about'),
          headers: getHeader(token: userToken),
        )
        .timeout(const Duration(seconds: 5), onTimeout: () => http.Response('{"status": "error"}', 408));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          var consentsList = jsonResponse['data'] as List;
          return consentsList.map((i) => AboutItem.fromJson(i)).toList();
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return [];
  }

  static Future<AboutItemDetail?> fetchAboutItemDetail(String userToken, String consentId, {String? language}) async {
    final response = await http
        .get(
          Uri.parse('$BASE_URL/mobile/setting/about/$consentId'),
          headers: getHeader(token: userToken),
        )
        .timeout(const Duration(seconds: 5), onTimeout: () => http.Response('{"status": "error"}', 408));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return AboutItemDetail.fromJson(jsonResponse['data']);
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<bool> logout(String userToken, String? language) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/setting/logout'),
      headers: getPostHeader(token: userToken),
    );

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
