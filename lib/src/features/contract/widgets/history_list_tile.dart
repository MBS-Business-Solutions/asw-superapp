import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/utils/date_formatter_util.dart';
import 'package:flutter/material.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';

class HistoryListTile extends StatelessWidget {
  const HistoryListTile({super.key, required this.paymentDetail, this.onTap});
  final PaymentDetail paymentDetail;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final isWaiting = paymentDetail.status == 'รอยืนยันเงิน';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: buildItemCardDecoration(context),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: mDefaultPadding, right: mDefaultPadding),
        onTap: onTap,
        // contentPadding: EdgeInsets.zero,
        title: Text.rich(TextSpan(children: [
          TextSpan(text: DateFormatterUtil.formatFullDate(context, paymentDetail.date), style: Theme.of(context).textTheme.titleSmall),
        ])),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(AppLocalizations.of(context)!.priceFormatBaht(paymentDetail.amount),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: isWaiting
                                ? CommonUtil.colorTheme(context, darkColor: mDarkUnPaidColor, lightColor: mLightUnPaidColor)
                                : CommonUtil.colorTheme(context, darkColor: mDarkPaidColor, lightColor: mLightPaidColor),
                          )),
                ),
                PaymentStatusTag(paymentDetail: paymentDetail, isWaiting: isWaiting)
              ],
            ),
            Row(
              children: [
                Expanded(child: Text(paymentDetail.type ?? '')),
                if (!isWaiting)
                  Row(
                    children: [
                      const Icon(
                        Icons.receipt_long_sharp,
                        size: 18,
                      ),
                      Text(
                        paymentDetail.receiptNumber,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentStatusTag extends StatelessWidget {
  const PaymentStatusTag({
    super.key,
    required this.paymentDetail,
    required this.isWaiting,
  });

  final PaymentDetail paymentDetail;
  final bool isWaiting;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor(context),
        borderRadius: BorderRadius.circular(99),
      ),
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(paymentDetail.status,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: isWaiting
                    ? CommonUtil.colorTheme(context, darkColor: mDarkUnPaidColor, lightColor: mLightUnPaidColor)
                    : CommonUtil.colorTheme(context, darkColor: mDarkPaidColor, lightColor: mLightPaidColor),
              )),
    );
  }

  Color _backgroundColor(BuildContext context) {
    switch (paymentDetail.status) {
      case 'รอยืนยันเงิน':
        return CommonUtil.colorTheme(context, darkColor: mDarkUnPaidBGColor, lightColor: mLightUnPaidBGColor);
      default:
        return CommonUtil.colorTheme(context, darkColor: mDarkPaidBGColor, lightColor: mLightPaidBGColor);
    }
  }
}
