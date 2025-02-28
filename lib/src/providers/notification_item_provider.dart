import 'package:AssetWise/main.dart';
import 'package:AssetWise/src/models/aw_notification_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/aw_notification_item_service.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class NotificationItemProvider with ChangeNotifier {
  UserProvider? _userProvider;
  int _unreadAllCount = 2;
  int _unreadPaymentCount = 0;
  final int _unreadPromotionCount = 3;
  final int _unreadHotDealCount = 2;
  final int _unreadNewsCount = 1;

  int get unreadAllCount => _unreadAllCount;
  int get unreadPaymentCount => _unreadPaymentCount;
  int get unreadPromotionCount => _unreadPromotionCount;
  int get unreadHotDealCount => _unreadHotDealCount;
  int get unreadNewsCount => _unreadNewsCount;

  final List<NotificationItem> _notificationItems = [];

  void updateUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;

    // fetch with user token
    fetchNotificationItems();
  }

  Future<void> fetchNotificationItems() async {
    if (_userProvider == null) return;
    final notificationFromServer = await AwNotificationItemService.fetchNotificationItems(_userProvider!.token!);
    await isar.writeTxn(() async {
      await isar.notificationItems.clear();
      for (final item in notificationFromServer) {
        await isar.notificationItems.put(item);
      }
    });
    _notificationItems.clear();
    _notificationItems.addAll(isar.notificationItems.where().findAllSync());
    _reCount();
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    _unreadAllCount = 0;
    await isar.writeTxn(() async {
      for (final item in await isar.notificationItems.where().findAll()) {
        if (!item.isRead) {
          item.isRead = true;
          isar.notificationItems.put(item);
        }
      }
    });
    _reCount();
    notifyListeners();
  }

  void _reCount() {
    _unreadAllCount = _notificationItems.where((element) => !element.isRead).length;
  }
}
