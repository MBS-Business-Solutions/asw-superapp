import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AWContentService {
  // สำหรับแสดงผลเป็น Pop-up ก่อนใช้งานหน้า Dashboard
  static Future<List<String>> fetchCampaigns() async {
    final response = await http.get(Uri.parse('$BASE_URL/home/news'));

    if (response.statusCode == 200) {
      Map data = json.decode(response.body);
      return data['images'].cast<String>();
    } else {
      throw Exception('Failed to load campaigns');
    }
  }

  // สำหรับแสดงผลบนหน้า DashboardMainView
  static Future<List<String>> fetchBanners() async {
    final response = await http.get(Uri.parse('$BASE_URL/home/clubs'));

    if (response.statusCode == 200) {
      Map data = json.decode(response.body);
      return data['images'].cast<String>();
    } else {
      throw Exception('Failed to load campaigns');
    }
  }

  static Future<List<Project>> fetchProjects() async {
    final response = await http.get(Uri.parse('$BASE_URL/home/projects'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }
}
