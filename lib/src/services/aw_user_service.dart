import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_header_util.dart';
import 'package:AssetWise/src/utils/api_response_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AwUserService {
  AwUserService._privateConstructor();
  static final AwUserService _instance = AwUserService._privateConstructor();
  factory AwUserService() => _instance;

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

  Future<UserToken?> loginNewUser(
      {required String type,
      required String phone,
      required String email,
      required String firstName,
      required String lastName}) async {
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

  Future<bool> submitConsents(
      String token, String consentId, Map<String, bool> consents) async {
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

  Future<bool> setPreferedLanguage(String token, String language) async {
    final response = await http
        .post(
          Uri.parse('$BASE_URL/mobile/setting/language'),
          headers: getPostHeader(token: token),
          body: jsonEncode(<String, String>{"language": language}),
        )
        .timeout(const Duration(seconds: 5),
            onTimeout: () => http.Response('{"status": "error"}', 408));

    final handledResponse =
        await ApiResponseHandler.handleAuthenticatedResponse(response);

    if (handledResponse.statusCode >= 200 && handledResponse.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(handledResponse.body);
        if (jsonResponse['status'] == 'success') {
          return true;
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(handledResponse);
    return false;
  }

  Future<bool> updateFCMToken(String userToken, String fcmToken) async {
    final response = await http
        .post(
          Uri.parse('$BASE_URL/auth/fcm'),
          headers: getPostHeader(token: userToken),
          body: jsonEncode(<String, String>{"token": fcmToken}),
        )
        .timeout(const Duration(seconds: 5),
            onTimeout: () => http.Response('{"status": "error"}', 408));

    final handledResponse =
        await ApiResponseHandler.handleAuthenticatedResponse(response);

    if (handledResponse.statusCode >= 200 && handledResponse.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(handledResponse.body);
        if (jsonResponse['status'] == 'success') {
          return true;
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(handledResponse);
    return false;
  }

  Future<bool> changeEmail(String userToken, String newValue) async {
    final response = await http
        .post(
          Uri.parse('$BASE_URL/mobile/setting/change-email'),
          headers: getPostHeader(token: userToken),
          body: jsonEncode(<String, String>{"email": newValue}),
        )
        .timeout(const Duration(seconds: 5),
            onTimeout: () => http.Response('{"status": "error"}', 408));

    // จัดการ 401 error สำหรับ API ที่ใช้ token
    final handledResponse =
        await ApiResponseHandler.handleAuthenticatedResponse(response);

    if (handledResponse.statusCode >= 200 && handledResponse.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(handledResponse.body);
        if (jsonResponse['status'] == 'success') {
          return true;
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(handledResponse);
    return false;
  }

  Future<bool> changePhone(String userToken, String newValue) async {
    final response = await http
        .post(
          Uri.parse('$BASE_URL/mobile/setting/change-phone'),
          headers: getPostHeader(token: userToken),
          body: jsonEncode(<String, String>{"phone": newValue}),
        )
        .timeout(const Duration(seconds: 5),
            onTimeout: () => http.Response('{"status": "error"}', 408));

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

  Future<UserInformation?> getUserInformation(String userToken) async {
    final response = await http
        .get(
          Uri.parse('$BASE_URL/mobile/home/me'),
          headers: getHeader(token: userToken),
        )
        .timeout(const Duration(seconds: 5),
            onTimeout: () => http.Response('{"status": "error"}', 408));

    final handledResponse =
        await ApiResponseHandler.handleAuthenticatedResponse(response);

    if (handledResponse.statusCode >= 200 && handledResponse.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(handledResponse.body);
        if (jsonResponse['status'] == 'success') {
          return UserInformation.fromJson(jsonResponse['data']);
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(handledResponse);
    return null;
  }

  Future<List<PersonalConsent>> fetchPersonalConsents(String userToken,
      {String? language}) async {
    final response = await http
        .get(
          Uri.parse('$BASE_URL/mobile/setting/consent'),
          headers: getHeader(token: userToken),
        )
        .timeout(const Duration(seconds: 5),
            onTimeout: () => http.Response('{"status": "error"}', 408));

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

  Future<PersonalConsentDetail?> fetchPersonalConsentDetail(
      String userToken, String consentId,
      {String? language}) async {
    final response = await http
        .get(
          Uri.parse('$BASE_URL/mobile/setting/consent/$consentId'),
          headers: getHeader(token: userToken),
        )
        .timeout(const Duration(seconds: 5),
            onTimeout: () => http.Response('{"status": "error"}', 408));

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

  Future<bool> submitPersonalConsent(
      String userToken, String consentId, bool consentGiven) async {
    final response = await http
        .post(
          Uri.parse('$BASE_URL/mobile/setting/consent/$consentId'),
          headers: getPostHeader(token: userToken),
          body: jsonEncode({
            "is_given": consentGiven,
          }),
        )
        .timeout(const Duration(seconds: 5),
            onTimeout: () => http.Response('{"status": "error"}', 408));

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

  Future<List<AboutItem>> fetchAboutItems(String userToken,
      {String? language}) async {
    final response = await http
        .get(
          Uri.parse('$BASE_URL/mobile/setting/about'),
          headers: getHeader(token: userToken),
        )
        .timeout(const Duration(seconds: 5),
            onTimeout: () => http.Response('{"status": "error"}', 408));

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

  Future<AboutItemDetail?> fetchAboutItemDetail(
      String userToken, String consentId,
      {String? language}) async {
    final response = await http
        .get(
          Uri.parse('$BASE_URL/mobile/setting/about/$consentId'),
          headers: getHeader(token: userToken),
        )
        .timeout(const Duration(seconds: 5),
            onTimeout: () => http.Response('{"status": "error"}', 408));

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

  Future<bool> logout(String userToken, String? language) async {
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

  Future<MyQRResponse?> fetchMyQR(String userToken) async {
    final response = await http
        .get(
          Uri.parse('$BASE_URL/mobile/my-qr'),
          headers: getHeader(token: userToken),
        )
        .timeout(const Duration(seconds: 5),
            onTimeout: () => http.Response('{"status": "error"}', 408));

    if (response.statusCode >= 200 && response.statusCode < 500) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return MyQRResponse.fromJson(jsonResponse);
      } catch (e) {
        if (kDebugMode) print(e);
        return null;
      }
    }
    if (kDebugMode) print(response);
    return null;
  }

  Future<ServiceResponseWithData<Priviledge?>> fetchPriviledge(
      String userToken) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/privilege/url'),
      headers: getHeader(token: userToken),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = ServiceResponseWithData.fromJson(
          jsonResponse,
          (json) => Priviledge.fromJson(json),
        );
        return result;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponseWithData<Priviledge?>(
          status: 'error', message: e.toString(), data: null);
    }

    if (kDebugMode) print(response);
    return ServiceResponseWithData<Priviledge?>(
        status: 'error', message: 'Unknown error', data: null);
  }
}
