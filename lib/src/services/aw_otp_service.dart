import 'dart:convert';
import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_otp_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AwOtpService {
  static Future<OTPRef?> sendOTPForReLogin({required String token, required OTPRequest request, String? language}) async {
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
        'Content-Language': language ?? 'th',
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

  static Future<OTPRef?> sendOTPForValidateUser({required String token, required OTPRequest request, String? language}) async {
    final body = {
      "id_card": request.sendTo,
    };
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/setting/buyer-check'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Content-Language': language ?? 'th',
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

  static Future<OTPRef?> sendOTPForChangePin({required String token, required OTPRequest request, String? language}) async {
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
        'Content-Language': language ?? 'th',
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

  static Future<OTPRef?> sendOTPForUnitAdd({
    required String token,
    required String projectCode,
    required String unitNumber,
    required String last4Id,
    String? language,
  }) async {
    final body = {"project_code": projectCode, "unit_number": unitNumber, "id_card4": last4Id};
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/setting/unit-add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Content-Language': language ?? 'th',
      },
      body: jsonEncode(body),
    );
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 500) {
      return OTPRef.fromJson(jsonResponse);
    }
    if (kDebugMode) print(response);
    return OTPRef.fromJson({"code": response.statusCode, "status": "fail", 'message': 'error'});
  }

  static Future<OTPVerifyResponse?> verifyOTPForLogin({required String token, required String transId, required String otp, String? language}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/verify-login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Content-Language': language ?? 'th',
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

  static Future<OTPVerifyResponse?> verifyOTPForValidateUser({required String token, required String transId, required String otp, String? language}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/setting/verify-buyer-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Content-Language': language ?? 'th',
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

  static Future<OTPVerifyResponse?> verifyOTPForChangePin({required String token, required String transId, required String otp, String? language}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/setting/verify-change-pin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Content-Language': language ?? 'th',
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

  static Future<OTPAddUnitResponse?> verifyOTPForAddUnit({required String token, required String transId, required String otp, String? language}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/setting/verify-unit-add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Content-Language': language ?? 'th',
      },
      body: jsonEncode({
        "trans_id": transId,
        "otp": otp,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 500) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return OTPAddUnitResponse.fromJson(jsonResponse);
        // return OTPAddUnitResponse.fromJson({
        //   "code": 201,
        //   "status": "success",
        //   "data": {
        //     "email": "Chanyanut894@gmail.com",
        //     "phone": "0994926691",
        //     "unit_id": "da916b51-0796-4412-947b-c6ad8551938f",
        //     "project_id": "W8C001",
        //     "contract_id": "SO-W8C001-25020005",
        //     "customer_id": "39ec08dd-6cea-4066-835c-13507a6bdbd8",
        //     "unit_number": "B209",
        //     "house_number": "78/245",
        //     "project_name": "แอทโมซ โฟลว์ มีนบุรี",
        //     "project_type": "C",
        //     "contract_number": "CO-W8C001-250025",
        //     "project_name_en": "Atmoz Flow Minburi"
        //   }
        // });
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    if (kDebugMode) print(response);
    return null;
  }
}
