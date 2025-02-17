import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/utils/date_formatter_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryListTile extends StatelessWidget {
  const HistoryListTile({super.key, required this.paymentDetail, required this.selectedLocale, this.onTap});
  final PaymentDetail paymentDetail;
  final SupportedLocales selectedLocale;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final isWaiting = paymentDetail.status == 'รอยืนยันเงิน';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: const Color(0xFF585858)),
        borderRadius: BorderRadius.circular(16),
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
        onTap: onTap,
        // contentPadding: EdgeInsets.zero,
        title: Text.rich(TextSpan(children: [
          TextSpan(text: DateFormatterUtil.formatFullDate(context, paymentDetail.date), style: Theme.of(context).textTheme.titleSmall),
          const TextSpan(text: ' '),
          TextSpan(text: DateFormatterUtil.formatTime(context, paymentDetail.date), style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: const Color(0xFF787878))),
        ])),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(AppLocalizations.of(context)!.priceFormatBaht(paymentDetail.amount),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: isWaiting ? mBrightPrimaryColor : mPaidColor,
                          )),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? mDarkCardBackgroundColor : mLightCardBackgroundColor,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(paymentDetail.status,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: isWaiting ? mBrightPrimaryColor : mPaidColor,
                          )),
                )
              ],
            ),
            Row(
              children: [
                Expanded(child: Text(paymentDetail.type)),
                if (!isWaiting)
                  Row(
                    children: [
                      const Icon(
                        Icons.receipt_long_sharp,
                        size: 18,
                      ),
                      Text(
                        paymentDetail.receiptNumber,
                        style: const TextStyle(color: Colors.white),
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
