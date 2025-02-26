import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/notifications/notifications_view.dart';
import 'package:AssetWise/src/providers/notification_item_provider.dart';
import 'package:AssetWise/src/widgets/hot_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardNotificationSection extends StatelessWidget {
  const DashboardNotificationSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationItemProvider>();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.dashboardMainSectionNotification,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            // GestureDetector(
            //   onTap: () {},
            //   child: Row(
            //     children: [
            //       Text(AppLocalizations.of(context)!.dashboardMainSectionFavouriteMore),
            //       const Icon(
            //         Icons.chevron_right,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: mDefaultPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HotMenuWidget(
              iconAsset: 'assets/icons/PriceCheckSharp.svg',
              titleText: AppLocalizations.of(context)!.notificationPayment,
              badgeCount: provider.unreadPaymentCount,
              onTap: () => Navigator.pushNamed(context, NotificationsView.routeName, arguments: {'selectedIndex': 1}),
            ),
            HotMenuWidget(
              iconAsset: 'assets/icons/Campaign.svg',
              titleText: AppLocalizations.of(context)!.notificationPromotion,
              badgeCount: provider.unreadPromotionCount,
              onTap: () => Navigator.pushNamed(context, NotificationsView.routeName, arguments: {'selectedIndex': 2}),
            ),
            HotMenuWidget(
              iconAsset: 'assets/icons/hot_deal.svg',
              titleText: AppLocalizations.of(context)!.notificationHotDeal,
              badgeCount: provider.unreadHotDealCount,
              onTap: () => Navigator.pushNamed(context, NotificationsView.routeName, arguments: {'selectedIndex': 3}),
            ),
            HotMenuWidget(
              iconAsset: 'assets/icons/news.svg',
              titleText: AppLocalizations.of(context)!.notificationNews,
              badgeCount: provider.unreadNewsCount,
              onTap: () => Navigator.pushNamed(context, NotificationsView.routeName, arguments: {'selectedIndex': 4}),
            ),
          ],
        ),
        const SizedBox(height: mDefaultPadding),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: mMediumPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 5,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                const Icon(Icons.price_check_sharp, color: mRedColor),
                const SizedBox(width: mMediumPadding),
                Text('ชำระค่างวด ธันวาคม 2567', style: Theme.of(context).textTheme.labelLarge!.copyWith(color: mRedColor)),
                const Spacer(),
                Text('15:36 น.', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: mSmallPadding),
              child: Text(
                'เรียน คุณสมชาย ท่านมีรายการชำระค่างวด ธันวาคม 2567 จำนวน 1 รายการ รายละเอียดเพิ่มเติม',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
