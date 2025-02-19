import 'package:AssetWise/main.dart';
import 'package:AssetWise/src/models/aw_notification_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:isar/isar.dart';

class AwNotificationItemService {
  static Future<List<NotificationItem>> fetchNotificationItems() async {
    final list = List.generate(
        20,
        (index) => NotificationItem(
              id: '$index',
              title: 'Notification $index',
              createAt: DateTime.now(),
              message: 'This is a notification message $index',
              group: 'Payment',
            ));
    await isar.writeTxn(() async {
      isar.notificationItems.clear();
      await isar.notificationItems.putAll(list);
    });

    return isar.notificationItems.where().findAll();
  }
}
