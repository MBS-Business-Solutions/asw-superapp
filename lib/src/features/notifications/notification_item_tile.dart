import 'dart:convert';

import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/features/notifications/notification_item_theme.dart';
import 'package:AssetWise/src/models/aw_notification_model.dart';
import 'package:AssetWise/src/providers/notification_item_provider.dart';
import 'package:flutter/material.dart';
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
    final timeFormatter = DateFormat('HH:mm');
    return ListTile(
      onTap: () async {
        // mark read
        await context.read<NotificationItemProvider>().markAsRead(id: notificationItem.id);
        if (notificationItem.data == null) return;
        final data = jsonDecode(notificationItem.data!);
        Navigator.pushNamed(context, ContractsView.routeName, arguments: {'linkId': data['contract_id']});
      },
      tileColor: notificationItem.isRead ? null : theme!.unreadBackgroundColor,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme!.paymentIconBackgroundColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                color: theme.paymentIconColor,
              )),
          const SizedBox(
            width: mDefaultPadding,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _lang(preferedLanguage, en: notificationItem.titleEn, th: notificationItem.titleTh),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: notificationItem.isRead ? theme.readHeaderTextColor : theme.unreadHeaderTextColor),
                ),
                Text(
                  _lang(preferedLanguage, en: notificationItem.messageEn, th: notificationItem.messageTh),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: notificationItem.isRead ? theme.readTextColor : theme.unreadTextColor),
                ),
                Text(timeFormatter.format(notificationItem.createAt), style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: theme.timeTextColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _lang(String preferedLanguage, {required String th, required String en}) {
    return preferedLanguage == 'en' ? en : th;
  }
}
