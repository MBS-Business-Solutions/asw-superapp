import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_header_util.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AwRegisterService {
  AwRegisterService._privateConstructor();
  static final AwRegisterService _instance = AwRegisterService._privateConstructor();
  factory AwRegisterService() => _instance;

  static Future<bool> customerCheck({String? idCard4, required String userName, String? language}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/customer-check'),
      headers: getPostHeader(),
      body: jsonEncode(<String, String>{
        if (idCard4 != null) "id_card4": idCard4,
        "username": userName,
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

  static Future<RegisterOTPRef?> sendOTPResident({required String idCard4, required String userName, String? language}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/request-resident-otp'),
      headers: getPostHeader(),
      body: jsonEncode(<String, String>{
        "id_card4": idCard4,
        "username": userName,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 500) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return RegisterOTPRef.fromJson(status: jsonResponse['status'], jsonResponse['data'], sendTo: userName, idCard: idCard4);
        } else {
          return RegisterOTPRef.fromJson(status: jsonResponse['status'], jsonResponse, sendTo: userName, idCard: idCard4);
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
      headers: getPostHeader(),
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

  static Future<RegisterOTPRef?> sendOTPNonResident({required String userName, String? language}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/request-person-otp'),
      headers: getPostHeader(),
      body: jsonEncode(<String, String>{
        "username": userName,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 500) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return RegisterOTPRef.fromJson(status: jsonResponse['status'], jsonResponse['data'], sendTo: userName);
        } else {
          return RegisterOTPRef.fromJson(status: jsonResponse['status'], jsonResponse, sendTo: userName);
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
      headers: getPostHeader(),
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
      headers: getHeader(token: token),
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
