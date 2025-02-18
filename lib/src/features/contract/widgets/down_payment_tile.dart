import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/utils/date_formatter_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DownPaymentTile extends StatelessWidget {
  const DownPaymentTile({
    super.key,
    required this.paymentDetail,
    this.onTap,
  });
  final DownPaymentDetail paymentDetail;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final isPaid = paymentDetail.status.isNotEmpty;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
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
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: mDefaultPadding, right: mDefaultPadding),
          onTap: onTap,
          // contentPadding: EdgeInsets.zero,
          title: Text.rich(TextSpan(children: [
            TextSpan(text: paymentDetail.termName, style: Theme.of(context).textTheme.titleSmall),
            const TextSpan(text: ' '),
            TextSpan(text: DateFormatterUtil.formatShortDate(context, paymentDetail.dueDate), style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: const Color(0xFF787878))),
          ])),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(AppLocalizations.of(context)!.priceFormatBaht(paymentDetail.amount),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: isPaid ? mPaidColor : mUnPaidColor,
                            )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? mDarkCardBackgroundColor : mLightCardBackgroundColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(bottom: 4),
                    child: Text(paymentDetail.status.isEmpty ? '**รอชำระ**' : paymentDetail.status,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: isPaid ? mPaidColor : mUnPaidColor,
                            )),
                  )
                ],
              ),
              if (isPaid)
                Row(
                  children: [
                    Expanded(child: Text(paymentDetail.payments.first.paymentType)),
                    Text(
                      paymentDetail.payments.first.receiptNumber,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
