import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_header_util.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AWContentService {
  static Future<String> fetchLandingBackgroundURL() async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/home/landing'),
      headers: getHeader(),
    );
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
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/home/campaigns'),
      headers: getHeader(),
    );

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
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/home/banners'),
      headers: getHeader(),
    );
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
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/home/projects'),
      headers: getHeader(),
    );

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

  static Future<ServiceResponseWithData<List<PromotionBanner>>> fetchPromotionBanners() async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/promotion/banner'),
      headers: getHeader(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = ServiceResponseWithData.fromJson(
          jsonResponse,
          (json) {
            List<dynamic>? data = jsonResponse['data'];
            if (data == null) {
              return <PromotionBanner>[];
            }
            return data.map((json) => PromotionBanner.fromJson(json)).toList();
          },
        );
        return result;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponseWithData<List<PromotionBanner>>(status: 'error', message: e.toString(), data: []);
    }

    if (kDebugMode) print(response);
    return ServiceResponseWithData<List<PromotionBanner>>(status: 'error', message: 'Unknown error', data: []);
  }

  static Future<ServiceResponseWithData<List<PromotionItem>>> fetchPromotions() async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/promotion'),
      headers: getHeader(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = ServiceResponseWithData.fromJson(
          jsonResponse,
          (json) {
            List<dynamic>? data = jsonResponse['data'];
            if (data == null) {
              return <PromotionItem>[];
            }
            return data.map((json) => PromotionItem.fromJson(json)).toList();
          },
        );
        return result;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponseWithData<List<PromotionItem>>(status: 'error', message: e.toString(), data: null);
    }

    if (kDebugMode) print(response);
    return ServiceResponseWithData<List<PromotionItem>>(status: 'error', message: 'Unknown error', data: null);
  }

  static Future<ServiceResponseWithData<PromotionItemDetail>> fetchPromotionDetail(int id) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/promotion/$id'),
      headers: getHeader(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = ServiceResponseWithData.fromJson(
          jsonResponse,
          (json) => PromotionItemDetail.fromJson(json),
        );
        return result;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponseWithData<PromotionItemDetail>(status: 'error', message: e.toString(), data: null);
    }

    if (kDebugMode) print(response);
    return ServiceResponseWithData<PromotionItemDetail>(status: 'error', message: 'Unknown error', data: null);
  }
}
