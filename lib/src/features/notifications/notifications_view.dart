import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/models/aw_notification_model.dart';
import 'package:AssetWise/src/providers/notification_item_provider.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/widgets/hot_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key, this.selectedIndex = 0});
  static const String routeName = '/notifications-and-news';
  final selectedIndex;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('แจ้งเตือนทั้งหมด'),
        actions: [
          Consumer<NotificationItemProvider>(
            builder: (context, provider, child) => TextButton(
                onPressed: () => context.read<NotificationItemProvider>().markAllAsRead(),
                child: Text(
                  'อ่านทั้งหมด${provider.unreadAllCount > 0 ? ' (${provider.unreadAllCount})' : ''}',
                  style: TextStyle(color: mPaidColor),
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
                    titleText: menus[index].keys.first,
                    iconAsset: menus[index].values.first,
                    highlight: _selectedIndex == index,
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
              child: Icon(Icons.notifications)),
          SizedBox(
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
