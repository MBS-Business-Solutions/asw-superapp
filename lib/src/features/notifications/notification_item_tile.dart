import 'dart:convert';

import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/features/notifications/notification_item_theme.dart';
import 'package:AssetWise/src/features/payments/payment_channels_view.dart';
import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:AssetWise/src/models/aw_notification_model.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
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
    final currentLocale = context.read<SettingsController>().supportedLocales;
    final timeFormatter = DateFormat('HH:mm${currentLocale.locale == 'th' ? ' น.' : ''}');
    return ListTile(
      onTap: () async {
        // mark read
        await context.read<NotificationItemProvider>().markAsRead(id: notificationItem.id);
        if (notificationItem.data == null) return;
        final data = jsonDecode(notificationItem.data!);

        if (data['contract_id'] != null) {
          final contractId = data['contract_id'];
          // find contract
          final contracts = await context.read<ContractProvider>().fetchContracts(context);
          final contract = contracts.firstWhere((element) => element.contractId == contractId);
          final overdueDetail = await context.read<ContractProvider>().fetchOverdueDetail(contractId);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentChannelsView(
                        contract: contract,
                        overdueDetail: overdueDetail,
                      )));
        }
        //Navigator.pushNamed(context, ContractsView.routeName, arguments: {'linkId': data['contract_id']});
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
                Text(timeFormatter.format(notificationItem.createAt),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: theme.timeTextColor,
                          fontWeight: FontWeight.bold,
                        )),
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
