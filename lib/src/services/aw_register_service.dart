import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AwRegisterService {
  static Future<bool> customerCheck({bool isByMobile = true, String? idCard4, required String phoneEmail}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/customer-check'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<OTPRef?> sendOTPResident({bool isLoginWithEmail = false, required String idCard4, required String phoneEmail}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/request-resident-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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
          return OTPRef.fromJson(jsonResponse['data'], sendTo: phoneEmail, isLoginWithEmail: isLoginWithEmail, idCard: idCard4);
        }
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<VerifyOTPResponse?> verifyOTPResident({required String transId, required String otp}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/verify-resident-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"trans_id": transId, "otp": otp}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return VerifyOTPResponse.fromJson(jsonResponse['data']);
        }
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
