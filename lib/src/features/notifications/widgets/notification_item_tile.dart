import 'dart:convert';

import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/contract/overdues_view.dart';
import 'package:AssetWise/src/features/notifications/widgets/notification_item_theme.dart';
import 'package:AssetWise/src/features/promotions/views/promotion_detail_view.dart';
import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:AssetWise/src/models/aw_notification_model.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/providers/notification_item_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/webview_with_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationItemTile extends StatelessWidget {
  const NotificationItemTile({
    super.key,
    required this.notificationItem,
    required this.preferedLanguage,
  });
  final NotificationItem notificationItem;
  final String preferedLanguage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<NotificationItemTileTheme>();
    final currentLocale = context.read<SettingsController>().supportedLocales;
    final timeFormatter = DateFormat('HH:mm${currentLocale.locale == 'th' ? ' น.' : ''}');
    final isPaymentNotification = notificationItem.type == 'overdue' || notificationItem.type == 'remind';
    Color? backgroundColor; // null for read notifications
    if (!notificationItem.isRead) {
      if (isPaymentNotification) {
        backgroundColor = theme?.unreadPaymentBackgroundColor;
      } else {
        backgroundColor = theme?.unreadOtherBackgroundColor;
      }
    }
    return ListTile(
      onTap: () => _linkTo(context, notificationItem),
      tileColor: backgroundColor,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _icon(notificationItem, theme),
          const SizedBox(
            width: mDefaultPadding,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _lang(preferedLanguage, en: notificationItem.titleEn, th: notificationItem.titleTh),
                  // maxLines: 1,
                  // overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: notificationItem.isRead ? theme?.readHeaderTextColor : theme?.unreadPaymentHeaderTextColor),
                ),
                Text(
                  _lang(preferedLanguage, en: notificationItem.messageEn, th: notificationItem.messageTh),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: notificationItem.isRead ? theme?.readTextColor : theme?.unreadTextColor),
                ),
                Text(timeFormatter.format(notificationItem.createAt),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: theme?.timeTextColor,
                          fontWeight: FontWeight.bold,
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _icon(NotificationItem item, NotificationItemTileTheme? theme) {
    var iconColor = theme?.paymentIconColor;
    var iconBackgroundColor = theme?.paymentIconBackgroundColor;
    // var iconData = Icons.account_balance_wallet_outlined;
    var iconAsset = 'assets/icons/PriceCheckSharp.svg';
    switch (item.type) {
      case 'overdue':
      case 'remind':
        iconColor = theme?.paymentIconColor;
        iconAsset = 'assets/icons/PriceCheckSharp.svg';
        iconBackgroundColor = theme?.paymentIconBackgroundColor;
        break;
      case 'promotion':
        iconColor = theme?.promotionIconColor;
        iconAsset = 'assets/icons/Campaign.svg';
        iconBackgroundColor = theme?.promotionIconBackgroundColor;
        break;
      case 'hotdeal':
        iconColor = theme?.hotDealIconColor;
        iconAsset = 'assets/icons/hot_deal.svg';
        iconBackgroundColor = theme?.hotDealIconBackgroundColor;
        break;
      case 'news':
        iconColor = theme?.newsIconColor;
        iconAsset = 'assets/icons/news.svg';
        iconBackgroundColor = theme?.newsIconBackgroundColor;
        break;
    }
    return Container(
      width: 40,
      height: 40,

      decoration: BoxDecoration(
        color: iconBackgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(
          iconAsset,
          colorFilter: ColorFilter.mode(
            iconColor!,
            BlendMode.srcIn,
          ),
        ),
      ),
      // child: Icon(
      //   iconData,
      //   color: iconColor,
      // ),
    );
  }

  String _lang(String preferedLanguage, {required String th, required String en}) {
    return preferedLanguage == 'en' ? en : th;
  }

  Future<void> _linkTo(BuildContext context, NotificationItem item) async {
    // mark read
    await context.read<NotificationItemProvider>().markAsRead(id: notificationItem.id);
    if (notificationItem.data == null) return;
    final data = jsonDecode(notificationItem.data!);
    if (item.type == 'overdue' || item.type == 'remind') {
      if (data['contract_id'] != null) {
        final contractId = data['contract_id'];
        // find contract
        final contracts = await context.read<ContractProvider>().fetchContracts(context);
        final contract = contracts.firstWhere((element) => element.contractId == contractId);
        // final overdueDetail = await context.read<ContractProvider>().fetchOverdueDetail(contractId);
        Navigator.pushNamed(context, OverduesView.routeName, arguments: {'contract': contract});
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => PaymentChannelsView(
        //               contract: contract,
        //               overdueDetail: overdueDetail,
        //             )));
      }
    } else if (item.type == 'promotion') {
      if (data['type'] == 'promotion') {
        final promotionId = CommonUtil.parseInt(data['promotion_id']);
        Navigator.pushNamed(context, PromotionDetailView.routeName, arguments: {'promotionId': promotionId});
      } else if (data['type'] == 'external') {
        final url = data['url'];
        if (url == null) return;
        Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewWithCloseButton(link: url)));
      }
    } else if (item.type == 'hotdeal') {
    } else if (item.type == 'news') {}
  }
}
