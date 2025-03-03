import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AwRegisterService {
  static Future<bool> customerCheck({bool isByMobile = true, String? idCard4, required String phoneEmail, String? language}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/customer-check'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Content-Language': language ?? 'th',
      },
      body: jsonEncode(<String, String>{
        "type": isByMobile ? "phone" : "email",
        if (idCard4 != null) "id_card4": idCard4,
        if (isByMobile) "phone": phoneEmail else "email": phoneEmail,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['status'] == 'success' && jsonResponse['data']['is_resident'];
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return false;
  }

  static Future<RegisterOTPRef?> sendOTPResident({bool isLoginWithEmail = false, required String idCard4, required String phoneEmail, String? language}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/request-resident-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Content-Language': language ?? 'th',
      },
      body: jsonEncode(<String, String>{
        "type": isLoginWithEmail ? 'email' : 'phone',
        "id_card4": idCard4,
        if (isLoginWithEmail) "email": phoneEmail else "phone": phoneEmail,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return RegisterOTPRef.fromJson(jsonResponse['data'], sendTo: phoneEmail, isLoginWithEmail: isLoginWithEmail, idCard: idCard4);
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<RegisterOTPVerifyResponse?> verifyOTPResident({required String transId, required String otp, String? language}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/verify-resident-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Content-Language': language ?? 'th',
      },
      body: jsonEncode(<String, String>{"trans_id": transId, "otp": otp}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return RegisterOTPVerifyResponse.fromJson(jsonResponse['data']);
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<RegisterOTPRef?> sendOTPNonResident({bool isLoginWithEmail = false, required String phoneEmail, String? language}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/request-person-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Content-Language': language ?? 'th',
      },
      body: jsonEncode(<String, String>{
        "type": isLoginWithEmail ? 'email' : 'phone',
        if (isLoginWithEmail) "email": phoneEmail else "phone": phoneEmail,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return RegisterOTPRef.fromJson(jsonResponse['data'], sendTo: phoneEmail, isLoginWithEmail: isLoginWithEmail);
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<RegisterOTPVerifyResponse?> verifyOTPNonResident({required String transId, required String otp, String? language}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/verify-person-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Content-Language': language ?? 'th',
      },
      body: jsonEncode(<String, String>{"trans_id": transId, "otp": otp}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return RegisterOTPVerifyResponse.fromJson(jsonResponse['data']);
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<Consent?> fetchConsent(String token, [String? language]) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/consent'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Language': language ?? 'th',
      },
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Consent.fromJson(jsonResponse['data']);
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return null;
  }
}
