import 'dart:convert';
import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_otp_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AwOtpService {
  static Future<OTPRef?> sendOTPForReLogin({required String token, required OTPRequest request}) async {
    final body = {
      "type": request.userType, // 'resident' | 'person'
      "otp_type": request.channel, // 'phone' | 'email'
      "id_card4": request.idCard4,
      "phone": request.phone,
      "email": request.email,
    };
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        if (jsonResponse['status'] == 'success') {
          return OTPRef.fromJson(jsonResponse);
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    } else {
      return OTPRef.fromJson(jsonResponse);
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<OTPRef?> sendOTPForValidateUser({required String token, required OTPRequest request}) async {
    final body = {
      "id_card": request.sendTo,
    };
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/setting/buyer-check'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return OTPRef.fromJson(jsonResponse);
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<OTPRef?> sendOTPForChangePin({required String token, required OTPRequest request}) async {
    final body = {
      "type": request.channel,
      "phone": request.phone,
      "email": request.email,
    };
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/setting/change-pin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return OTPRef.fromJson(jsonResponse);
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<OTPVerifyResponse?> verifyOTPForLogin({required String token, required String transId, required String otp}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/verify-login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "trans_id": transId,
        "otp": otp,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return OTPVerifyResponse.fromJson(jsonResponse);
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<OTPVerifyResponse?> verifyOTPForValidateUser({required String token, required String transId, required String otp}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/setting/verify-buyer-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "trans_id": transId,
        "otp": otp,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return OTPVerifyResponse.fromJson(jsonResponse);
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<OTPVerifyResponse?> verifyOTPForChangePin({required String token, required String transId, required String otp}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/setting/verify-change-pin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "trans_id": transId,
        "otp": otp,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return OTPVerifyResponse.fromJson(jsonResponse);
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return null;
  }
}
