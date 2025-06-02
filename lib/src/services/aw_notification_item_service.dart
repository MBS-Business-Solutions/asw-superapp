import 'dart:convert';
import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_notification_model.dart';
import 'package:AssetWise/src/services/aw_header_util.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AwNotificationItemService {
  AwNotificationItemService._privateConstructor();
  static final AwNotificationItemService _instance = AwNotificationItemService._privateConstructor();
  factory AwNotificationItemService() => _instance;

  Future<List<NotificationItem>> fetchNotificationItems(String token, {String? lastItemDate}) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/notifications${lastItemDate == null ? '' : '?cursor=$lastItemDate'}'),
      headers: getHeader(token: token),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return (jsonResponse['data']['items'] as List<dynamic>).map((item) => NotificationItem.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return [];
  }
}
