import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/notifications/widgets/notification_item_tile.dart';
import 'package:AssetWise/src/models/aw_notification_model.dart';
import 'package:AssetWise/src/providers/notification_item_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/hot_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key, this.selectedIndex = 0});
  static const String routeName = '/notifications-and-news';
  final int selectedIndex;
  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  int _selectedIndex = 0;

  List<Map<String, String>> menus = [
    {'ทั้งหมด': 'assets/icons/mail.svg'},
    {'ชำระค่างวด': 'assets/icons/PriceCheckSharp.svg'},
    {'โปรโมชั่น': 'assets/icons/Campaign.svg'},
    {'Hot Deal': 'assets/icons/hot_deal.svg'},
    {'ข่าวสาร': 'assets/icons/news.svg'}
  ];

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final preferedLanguage = Localizations.localeOf(context).languageCode;
    return Consumer<NotificationItemProvider>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            AppLocalizations.of(context)!.notificationTitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
                onPressed: () => context.read<NotificationItemProvider>().markAsRead(),
                child: Text(
                  '${AppLocalizations.of(context)!.notificationReadAll}${provider.unreadAllCount > 0 ? ' (${provider.unreadAllCount})' : ''}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: CommonUtil.colorTheme(context, darkColor: mDarkPaidColor, lightColor: mLightPaidColor),
                      ),
                )),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue, vertical: mMediumPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (var index = 0; index < menus.length; index++)
                    HotMenuWidget(
                      titleText: _menuTitle(index),
                      iconAsset: menus[index].values.first,
                      highlight: _selectedIndex == index,
                      badgeCount: badgeCount(index),
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final notificationItem = _list(_selectedIndex)[index];
                  return NotificationItemTile(
                    preferedLanguage: preferedLanguage,
                    notificationItem: notificationItem,
                  );
                },
                itemCount: _list(_selectedIndex).length,
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 1,
                    thickness: 1,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List<NotificationItem> _list(int index) {
    switch (index) {
      case 0:
        return context.read<NotificationItemProvider>().allNotification;
      case 1:
        return context.read<NotificationItemProvider>().paymentNotification;
      case 2:
        return context.read<NotificationItemProvider>().promotionNotification;
      case 3:
        return context.read<NotificationItemProvider>().hotDealNotification;
      case 4:
        return context.read<NotificationItemProvider>().newsNotification;
      default:
        return [];
    }
  }

  String _menuTitle(int index) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context)!.notificationAll;
      case 1:
        return AppLocalizations.of(context)!.notificationPayment;
      case 2:
        return AppLocalizations.of(context)!.notificationPromotion;
      case 3:
        return AppLocalizations.of(context)!.notificationHotDeal;
      case 4:
        return AppLocalizations.of(context)!.notificationNews;
      default:
        return '';
    }
  }

  int badgeCount(int index) {
    switch (index) {
      case 0:
        return context.read<NotificationItemProvider>().unreadAllCount;
      case 1:
        return context.read<NotificationItemProvider>().unreadPaymentCount;
      case 2:
        return context.read<NotificationItemProvider>().unreadPromotionCount;
      case 3:
        return context.read<NotificationItemProvider>().unreadHotDealCount;
      case 4:
        return context.read<NotificationItemProvider>().unreadNewsCount;
      default:
        return 0;
    }
  }
}
