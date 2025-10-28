import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_content_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier {
  List<ImageContent> _banners = [];
  List<ImageContent> get banners => _banners;
  List<Project> _suggestProjects = [];
  List<Project> get suggestProjects => _suggestProjects;

  Future<void> reload() async {
    await Future.wait([
      _fetchProjects(),
      _fetchBanners(),
    ]);
    notifyListeners();
  }

  Future<void> _fetchProjects() async {
    // 🔍 LOG: เริ่มเรียก API สำหรับ Suggest Projects
    if (kDebugMode) {
      print('=== DashboardProvider: เริ่มดึงข้อมูล SuggestProjects ===');
    }

    try {
      _suggestProjects = await AWContentService().fetchProjects();

      // 🔍 LOG: แสดงผลลัพธ์ที่ได้จาก API
      if (kDebugMode) {
        print('✅ DashboardProvider: ดึงข้อมูล SuggestProjects สำเร็จ');
        print('📊 จำนวนโปรเจคที่ได้: ${_suggestProjects.length}');

        if (_suggestProjects.isNotEmpty) {
          print('📋 รายการโปรเจคที่แนะนำ:');
          for (int i = 0; i < _suggestProjects.length && i < 3; i++) {
            final project = _suggestProjects[i];
            print('   ${i + 1}. ${project.name} (ID: ${project.id})');
          }
          if (_suggestProjects.length > 3) {
            print('   ... และอีก ${_suggestProjects.length - 3} โปรเจค');
          }
        } else {
          print('⚠️  API ไม่ได้ส่งข้อมูลโปรเจคกลับมา');
        }
        print('=================================================\n');
      }
    } catch (e) {
      // 🔍 LOG: แสดง error ถ้ามี
      if (kDebugMode) {
        print(
            '❌ DashboardProvider: เกิดข้อผิดพลาดในการดึงข้อมูล SuggestProjects');
        print('Error: $e');
        print('=================================================\n');
      }
      _suggestProjects = [];
      rethrow; // ส่ง error ต่อไป
    }
  }

  Future<void> _fetchBanners() async {
    _banners = await AWContentService().fetchBanners();
  }
}
