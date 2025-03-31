import 'dart:convert';
import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_otp_model.dart';
import 'package:AssetWise/src/services/aw_header_util.dart';
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
      headers: getPostHeader(token: token),
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
      headers: getPostHeader(token: token),
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 500) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return OTPRef.fromJson(jsonResponse);
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
      headers: getPostHeader(token: token),
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

  static Future<OTPRef?> sendOTPForUnitAdd({required String token, required String projectCode, required String unitNumber, required String last4Id}) async {
    final body = {
      "project_code": projectCode,
      "unit_number": unitNumber,
      "id_card4": last4Id,
    };
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/setting/unit-add'),
      headers: getPostHeader(token: token),
      body: jsonEncode(body),
    );
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 500) {
      return OTPRef.fromJson(jsonResponse);
    }
    if (kDebugMode) print(response);
    return OTPRef.fromJson({"code": response.statusCode, "status": "fail", 'message': 'error'});
  }

  static Future<OTPVerifyResponse?> verifyOTPForLogin({required String token, required String transId, required String otp}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/verify-login'),
      headers: getPostHeader(token: token),
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
      headers: getPostHeader(token: token),
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
      headers: getPostHeader(token: token),
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

  static Future<OTPAddUnitResponse?> verifyOTPForAddUnit({required String token, required String transId, required String otp}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/setting/verify-unit-add'),
      headers: getPostHeader(token: token),
      body: jsonEncode({
        "trans_id": transId,
        "otp": otp,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 500) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return OTPAddUnitResponse.fromJson(jsonResponse);
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return null;
  }
}
