import 'package:AssetWise/main.dart';
import 'package:AssetWise/src/features/dashboard/dashboard_view.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ApiResponseHandler {
  /// จัดการ HTTP response และตรวจสอบ 401 error
  /// ใช้สำหรับ API ที่ต้องใช้ token
  static Future<http.Response> handleAuthenticatedResponse(
      http.Response response) async {
    if (kDebugMode) {
      print(
          '🌐 API Response: ${response.statusCode} - ${response.request?.url}');
      if (response.statusCode >= 400) {
        print('❌ Error Response: ${response.body}');
      }
    }

    // จัดการ 401 Unauthorized
    if (response.statusCode == 401) {
      await _handle401Unauthorized();
    }

    return response;
  }

  /// จัดการเมื่อเจอ 401 Unauthorized
  static Future<void> _handle401Unauthorized() async {
    if (kDebugMode) {
      print('🚨 401 Unauthorized - Token expired or invalid');
    }

    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      try {
        // Logout ผู้ใช้
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.logout();

        if (kDebugMode) {
          print('✅ User logged out successfully');
        }

        // แสดง toast แจ้งเตือน
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                '🔐 เซสชันหมดอายุ กรุณาเข้าสู่ระบบใหม่',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 3),
            ),
          );

          // เด้งไปหน้าแรก (Dashboard) หลังจากแสดง toast
          await Future.delayed(const Duration(milliseconds: 500));

          if (context.mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              DashboardView.routeName,
              (route) => false,
            );

            if (kDebugMode) {
              print('🏠 Redirected to dashboard (home page)');
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error handling 401: $e');
        }
      }
    }
  }
}
