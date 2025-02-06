import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AWContentService {
  // สำหรับแสดงผลเป็น Pop-up ก่อนใช้งานหน้า Dashboard
  static Future<List<ImageContent>> fetchCampaigns() async {
    final response = await http.get(Uri.parse('$BASE_URL/home/campaigns'));

    try {
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => ImageContent.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // สำหรับแสดงผลบนหน้า DashboardMainView
  static Future<List<ImageContent>> fetchBanners() async {
    final response = await http.get(Uri.parse('$BASE_URL/home/banners'));

    try {
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => ImageContent.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Project>> fetchProjects() async {
    final response = await http.get(Uri.parse('$BASE_URL/home/projects'));

    try {
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Project.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
