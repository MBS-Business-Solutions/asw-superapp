import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/models/aw_notification_model.dart';
import 'package:AssetWise/src/providers/notification_item_provider.dart';
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
    {'โปรโมชั่น': 'assets/icons/questionaire.svg'},
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          AppLocalizations.of(context)!.notificationTitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          Consumer<NotificationItemProvider>(
            builder: (context, provider, child) => TextButton(
                onPressed: () => context.read<NotificationItemProvider>().markAllAsRead(),
                child: Text(
                  '${AppLocalizations.of(context)!.notificationReadAll}${provider.unreadAllCount > 0 ? ' (${provider.unreadAllCount})' : ''}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: mPaidColor),
                )),
          ),
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
                return NotificationItemTile(
                  notificationItem:
                      NotificationItem.fromJson({"id": "7f074112-ceb5-4b32-97c4-eb506e878933", "title": "ทดสอบ", "message": "ทดสอบ api ว่ามีรายการขึ้นมาไหม", "create_at": "2025-02-07T10:12:46.394Z"}),
                );
              },
              itemCount: 3,
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
    );
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

class NotificationItemTile extends StatelessWidget {
  const NotificationItemTile({
    super.key,
    required this.notificationItem,
  });
  final NotificationItem notificationItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, ContractsView.routeName, arguments: 'contract');
      },
      tileColor: mTileWarnColor,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: mRedColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.account_balance_wallet_outlined)),
          const SizedBox(
            width: mDefaultPadding,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ชำระค่างวด ธันวาคม 2567',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text('15:36 น.', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: mGreyColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
