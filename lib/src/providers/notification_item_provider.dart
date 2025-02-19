import 'package:AssetWise/main.dart';
import 'package:AssetWise/src/models/aw_notification_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/aw_notification_item_service.dart';
import 'package:flutter/material.dart';

class NotificationItemProvider with ChangeNotifier {
  UserProvider? _userProvider;
  int _unreadAllCount = 2;
  int _unreadPaymentCount = 0;
  int _unreadPromotionCount = 3;
  int _unreadHotDealCount = 2;
  int _unreadNewsCount = 1;

  int get unreadAllCount => _unreadAllCount;
  int get unreadPaymentCount => _unreadPaymentCount;
  int get unreadPromotionCount => _unreadPromotionCount;
  int get unreadHotDealCount => _unreadHotDealCount;
  int get unreadNewsCount => _unreadNewsCount;

  void updateUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;

    // fetch with user token
    fetchNotificationItems();
  }

  Future<void> fetchNotificationItems() async {
    final notificationItems = await AwNotificationItemService.fetchNotificationItems();

    _unreadPaymentCount = 5;
    _reCount();
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    _unreadAllCount = 0;
    final notificationItems = await AwNotificationItemService.fetchNotificationItems();
    await isar.writeTxn(() async {
      for (final item in notificationItems) {
        if (!item.isRead) {
          item.isRead = true;
          isar.notificationItems.put(item);
        }
      }
    });
    _reCount();
    notifyListeners();
  }

  void _reCount() {}
}
