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
  int _unreadPromotionCount = 3;
  int _unreadHotDealCount = 2;
  int _unreadNewsCount = 1;

  int get unreadAllCount => _unreadAllCount;
  int get unreadPaymentCount => _unreadPaymentCount;
  int get unreadPromotionCount => _unreadPromotionCount;
  int get unreadHotDealCount => _unreadHotDealCount;
  int get unreadNewsCount => _unreadNewsCount;

  final List<NotificationItem> _notificationItems = [];
  List<NotificationItem> get allNotification => _notificationItems;
  List<NotificationItem> get paymentNotification => _notificationItems.where((element) => element.type == 'overdue' || element.type == 'remind').toList();
  List<NotificationItem> get promotionNotification => _notificationItems.where((element) => element.type == 'promotion').toList();
  List<NotificationItem> get hotDealNotification => _notificationItems.where((element) => element.type == 'hotdeal').toList();
  List<NotificationItem> get newsNotification => _notificationItems.where((element) => element.type == 'news').toList();

  NotificationItemProvider() {
    _reload();
    _reCount();
  }

  void updateUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
    // reload from isar db if available
    _reload();
    _reCount();
    // fetch with user token
    fetchNotificationItems();
  }

  Future<void> fetchNotificationItems() async {
    if (_userProvider == null || _userProvider?.token == null) return;
    final notificationFromServer = await AwNotificationItemService.fetchNotificationItems(
      _userProvider!.token!,
      lastItemDate: _notificationItems.isNotEmpty ? _notificationItems.last.timeStamp : null,
    );
    await isar.writeTxn(() async {
      // _notificationItems.clear();
      // await isar.notificationItems.clear();
      for (final item in notificationFromServer) {
        await isar.notificationItems.put(item);
      }
    });
    _reload();
    _reCount();
    notifyListeners();
  }

  Future<void> markAsRead({String? id}) async {
    _resetCount();
    await isar.writeTxn(() async {
      if (id != null) {
        final item = await isar.notificationItems.where().filter().idEqualTo(id).findFirst();
        if (item != null && !item.isRead) {
          item.isRead = true;
          isar.notificationItems.put(item);
        }
      } else {
        // read all
        for (final item in await isar.notificationItems.where().findAll()) {
          if (!item.isRead) {
            item.isRead = true;
            await isar.notificationItems.put(item);
          }
        }
      }
    });
    _reload();
    _reCount();
    notifyListeners();
  }

  void _reload() {
    if (isar.isOpen) {
      _notificationItems.clear();
      _notificationItems.addAll(isar.notificationItems.where().findAllSync());
    }
  }

  void _reCount() {
    _unreadAllCount = _notificationItems.where((element) => !element.isRead).length;
    _unreadPaymentCount = _notificationItems.where((element) => (element.type == 'overdue' || element.type == 'remind') && !element.isRead).length;
    _unreadPromotionCount = _notificationItems.where((element) => element.type == 'promotion' && !element.isRead).length;
    _unreadHotDealCount = _notificationItems.where((element) => element.type == 'hotdeal' && !element.isRead).length;
    _unreadNewsCount = _notificationItems.where((element) => element.type == 'news' && !element.isRead).length;
  }

  void _resetCount() {
    _unreadAllCount = 0;
    _unreadPaymentCount = 0;
    _unreadPromotionCount = 0;
    _unreadHotDealCount = 0;
    _unreadNewsCount = 0;
  }
}
