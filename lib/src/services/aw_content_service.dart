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
}
