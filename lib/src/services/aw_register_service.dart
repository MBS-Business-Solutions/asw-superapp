import 'package:AssetWise/src/consts/url_const.dart';
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

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        String status = jsonResponse['status'];
        if (status == 'success') {
          return jsonResponse['data']['is_resident'];
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> sendOTP({bool isByMobile = true, String? idCard4, required String phoneEmail}) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "type": isByMobile ? "phone" : "email",
        if (idCard4 != null) "id_card4": idCard4,
        if (isByMobile) "phone": phoneEmail else "email": phoneEmail,
      }),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        String status = jsonResponse['status'];
        if (status == 'success') {
          return jsonResponse['data']['is_resident'];
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
