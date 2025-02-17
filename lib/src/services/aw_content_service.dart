import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AWContentService {
  static Future<String> fetchLandingBackgroundURL() async {
    final response = await http.get(Uri.parse('$BASE_URL/mobile/home/landing'));
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data']['image'];
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return '';
    }
    if (kDebugMode) print(response);
    return '';
  }

  // สำหรับแสดงผลเป็น Pop-up ก่อนใช้งานหน้า Dashboard
  static Future<List<ImageContent>> fetchCampaigns() async {
    final response = await http.get(Uri.parse('$BASE_URL/mobile/home/campaigns'));

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((json) => ImageContent.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return [];
    }
    if (kDebugMode) print(response);
    return [];
  }

  // สำหรับแสดงผลบนหน้า DashboardMainView
  static Future<List<ImageContent>> fetchBanners() async {
    final response = await http.get(Uri.parse('$BASE_URL/mobile/home/banners'));
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((json) => ImageContent.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return [];
    }
    if (kDebugMode) print(response);
    return [];
  }

  static Future<List<Project>> fetchProjects() async {
    final response = await http.get(Uri.parse('$BASE_URL/mobile/home/projects'));

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((json) => Project.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return [];
    }

    if (kDebugMode) print(response);
    return [];
  }

  static Future<Consent?> fetchConsent(String token) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/consent'),
      headers: {
        'Authorization': 'Bearer $token',
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
        return ContractDetail.fromJson(jsonResponse['data']);
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return null;
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
}
