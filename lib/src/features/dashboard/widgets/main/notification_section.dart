import 'dart:convert';
import 'dart:math';

import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/contract/overdues_view.dart';
import 'package:AssetWise/src/features/notifications/notifications_view.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/providers/notification_item_provider.dart';
import 'package:AssetWise/src/widgets/hot_menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        ..._buildUnpaidItems(context),
      ],
    );
  }

  List<Widget> _buildUnpaidItems(BuildContext context) {
    final unpaidList = context.watch<NotificationItemProvider>().paymentNotification.where((element) => !element.isRead).toList();
    final preferedLanguage = Localizations.localeOf(context).languageCode;
    final timeFormatter = DateFormat('HH:mm');
    // Cap only 3 items
    final result = List.generate(min(3, unpaidList.length), (index) {
      final item = unpaidList[index];
      return Container(
        margin: const EdgeInsets.only(top: mDefaultPadding),
        padding: const EdgeInsets.only(left: mDefaultPadding, right: mDefaultPadding),
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
          onTap: () async {
            await context.read<NotificationItemProvider>().markAsRead(id: item.id);
            if (item.data == null) return;
            final data = jsonDecode(item.data!);
            if (data['contract_id'] != null) {
              final contractId = data['contract_id'];
              // find contract
              final contracts = await context.read<ContractProvider>().fetchContracts(context);
              final contract = contracts.firstWhere((element) => element.contractId == contractId);
              // final overdueDetail = await context.read<ContractProvider>().fetchOverdueDetail(contractId);
              Navigator.pushNamed(context, OverduesView.routeName, arguments: {'contract': contract});
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => PaymentChannelsView(
              //         contract: contract,
              //         overdueDetail: overdueDetail,
              //       ),
              //     ),
              //   );
            }
          },
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              const Icon(Icons.price_check_sharp, color: mRedColor),
              const SizedBox(width: mMediumPadding),
              Expanded(
                child: Text(
                  preferedLanguage == 'en' ? item.titleEn : item.titleTh,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(color: mRedColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: mMediumPadding),
              Text(timeFormatter.format(item.createAt), style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: mSmallPadding),
            child: Text(
              preferedLanguage == 'en' ? item.messageEn : item.messageTh,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      );
    });
    return result;
  }
}
