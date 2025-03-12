import 'dart:io';

import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/services/aw_header_util.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class AwContractService {
  static Future<List<Contract>> fetchContracts({required String token}) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/contracts'),
      headers: getHeader(token: token),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((json) => Contract.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return [];
  }

  static Future<ContractDetail?> fetchContractDetail(String token, String contractId) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/contracts/$contractId'),
      headers: getHeader(token: token),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final contractDetail = ContractDetail.fromJson(jsonResponse['data']);
        contractDetail.freebies = await fetchFreebies(token: token, contractId: contractId);
        return contractDetail;
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<List<String>> fetchFreebies({required String token, required String contractId}) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/contracts/$contractId/promotions'),
      headers: getHeader(token: token),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((json) => json.toString()).toList();
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return [];
  }

  static Future<List<PaymentDetail>?> fetchPaymentsByYear({required String token, required String contractId, required int year}) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/contracts/$contractId/payments?year=$year'),
      headers: getHeader(token: token),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((json) => PaymentDetail.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<OverdueDetail?> fetchOverdueDetail({required String token, required String contractId}) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/contracts/$contractId/overdue'),
      headers: getHeader(token: token),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return OverdueDetail.fromJson(jsonResponse['data']);
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<ReceiptDetail?> fetchReceiptDetail({required String token, required String contractId, required String receiptNumber}) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/contracts/$contractId/payments/$receiptNumber'),
      headers: getHeader(token: token),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return ReceiptDetail.fromJson(jsonResponse['data']);
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<List<DownPaymentDetail>> fetchTerms({required String token, required String contractId}) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/contracts/$contractId/terms'),
      headers: getHeader(token: token),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((json) => DownPaymentDetail.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return [];
  }

  static Future<List<DownPaymentTermDue>> fetchDownPaymentDues({required String token, required String contractId}) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/contracts/$contractId/terms-due'),
      headers: getHeader(token: token),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((json) => DownPaymentTermDue.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return [];
  }

  static String getViewReceiptURL(String contractId, String receiptNumber) {
    return '$BASE_URL/mobile/contracts/$contractId/payments/$receiptNumber/view';
  }

  static String getReceiptURL(String contractId, String receiptNumber) {
    return '$BASE_URL/mobile/contracts/$contractId/payments/$receiptNumber/download';
  }

  static Future<QRResponse?> getQRPaymentCode({required String token, required String contractId, double amount = 0, String? language}) async {
    final formatNumber = NumberFormat('####.00');
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/contracts/$contractId/qr-code?amount=${formatNumber.format(amount)}'),
      headers: getHeader(token: token),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return QRResponse.fromJson(jsonResponse);
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<PaymentGatewayResponse?> getPaymentGatewayURL({required String token, required Contract contract, double amount = 0, String? detail, required String email}) async {
    final formatNumber = NumberFormat('####.00');
    final body = {
      'payment_type': '9',
      'contract_id': contract.contractId,
      'contract_number': contract.contractNumber ?? '',
      'total': formatNumber.format(amount),
      'customer_email': email,
      'detail': detail ?? '',
    };
    final response = await http.post(
      Uri.parse('$BASE_URL/payment/link'),
      headers: getPostHeader(token: token),
      body: jsonEncode(body),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return PaymentGatewayResponse.fromJson(jsonResponse);
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<String?> downloadFile({required String token, required String url, required String fileName}) async {
    final response = await http.get(
      Uri.parse(url),
      headers: getHeader(token: token),
    );

    try {
      if (response.statusCode == 200) {
        // สร้าง directory ถ้ายังไม่มี
        final downloadDirectory = await _prepareDownloadDirectory();
        final filePath = "$downloadDirectory/$fileName.pdf";
        // เขียนไฟล์ลงเครื่อง
        final file = File(filePath);

        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        if (kDebugMode) {
          print("Failed to download PDF");
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return null;
  }

  static String getContractURL(String contractId) {
    return '$BASE_URL/mobile/contracts/$contractId/download';
  }

  static Future<String> _prepareDownloadDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadDirectory = Directory("${directory.path}/downloads");
    if (!await downloadDirectory.exists()) {
      await downloadDirectory.create(recursive: true);
    }
    // Delete all files in the downloads directory
    if (await downloadDirectory.exists()) {
      final files = downloadDirectory.listSync();
      for (var file in files) {
        if (file is File) {
          await file.delete();
        }
      }
    }
    return downloadDirectory.path;
  }

  static Future<bool> setDefaultContract({required String token, required String unitId}) async {
    final body = {
      'unit_id': unitId,
    };
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/setting/units/$unitId/default'),
      headers: getPostHeader(token: token),
      body: jsonEncode(body),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return false;
  }

  static Future<ServiceResponse?> removeContract({required String token, required String unitId}) async {
    final body = {
      'unit_id': unitId,
    };
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/setting/units/$unitId/remove'),
      headers: getPostHeader(token: token),
      body: jsonEncode(body),
    );

    try {
      return ServiceResponse.fromJson(json.decode(response.body));
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<List<ContractProject>> fetchProjects({required String token}) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/setting/projects'),
      headers: getHeader(token: token),
    );
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((json) => ContractProject.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return [];
  }
}
