import 'dart:io';

import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class AwContractService {
  static Future<List<Contract>> fetchContracts(String token) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/contracts'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final contractDetail = ContractDetail.fromJson(jsonResponse['data']);
        contractDetail.freebies = await fetchFreebies(token, contractId);
        return contractDetail;
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<List<String>> fetchFreebies(String token, String contractId) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/contracts/$contractId/promotions'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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

  static Future<List<PaymentDetail>?> fetchPaymentsByYear(String token, String contractId, int year) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/contracts/$contractId/payments?year=$year'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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

  static Future<OverdueDetail?> fetchOverdueDetail(String token, String contractId) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/contracts/$contractId/overdue'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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

  static Future<ReceiptDetail?> fetchReceiptDetail(String token, String contractId, String receiptNumber) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/contracts/$contractId/payments/$receiptNumber'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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

  static Future<List<DownPaymentDetail>> fetchTerms(String token, String contractId) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/contracts/$contractId/terms'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((json) => DownPaymentDetail.fromJson(json)).toList().reversed.toList();
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return [];
  }

  static Future<List<DownPaymentTermDue>> fetchDownPaymentDues(String token, String contractId) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/contracts/$contractId/terms-due'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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
    final pdfUrl = getReceiptURL(contractId, receiptNumber);
    return '${Platform.isAndroid ? 'https://docs.google.com/gview?embedded=true&url=' : ''}$pdfUrl';
  }

  static String getReceiptURL(String contractId, String receiptNumber) {
    return '$BASE_URL/mobile/contracts/$contractId/payments/$receiptNumber/download';
  }

  static Future<String?> getQRPaymentCode(String token, {required String contractId, double amount = 0}) async {
    final formatNumber = NumberFormat('####.00');
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/contracts/$contractId/qr-code?amount=${formatNumber.format(amount)}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data']['qr_code'];
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return null;
  }

  static Future<String?> getPaymentGatewayURL({required Contract contract, double amount = 0, String? detail, required String email}) async {
    final formatNumber = NumberFormat('####.00');
    final response = await http.post(
      Uri.parse('$BASE_URL/payment/link'),
      body: {
        'payment_type': '9',
        'contract_id': contract.contractId,
        'contract_number': contract.contractNumber ?? '',
        'total': formatNumber.format(amount),
        'email': email,
        'detail': detail ?? '',
      },
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data']['payment_url'];
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return null;
  }
}
