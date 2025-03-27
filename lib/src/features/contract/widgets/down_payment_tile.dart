import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/utils/common_util.dart';
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
    final isPaid = paymentDetail.statusCode == 'Complete';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      decoration: buildItemCardDecoration(context),
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
                    child: Text(AppLocalizations.of(context)!.priceFormatBahtDouble(paymentDetail.amount),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: CommonUtil.colorTheme(context, darkColor: mDarkPaidColor, lightColor: mLightPaidColor),
                            )),
                  ),
                  if (paymentDetail.status.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: isPaid
                            ? CommonUtil.colorTheme(context, darkColor: mDarkPaidBGColor, lightColor: mLightPaidBGColor)
                            : CommonUtil.colorTheme(context, darkColor: mDarkUnPaidBGColor, lightColor: mLightUnPaidBGColor),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Text(paymentDetail.status,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: isPaid
                                    ? CommonUtil.colorTheme(context, darkColor: mDarkPaidColor, lightColor: mLightPaidColor)
                                    : CommonUtil.colorTheme(context, darkColor: mDarkUnPaidColor, lightColor: mLightUnPaidColor),
                              )),
                    )
                ],
              ),
              if (isPaid) ...[
                for (final payment in paymentDetail.payments)
                  Row(
                    children: [
                      Expanded(child: Text(payment.paymentType)),
                      const Spacer(),
                      const Icon(
                        Icons.receipt_long_outlined,
                        size: 14,
                      ),
                      const SizedBox(
                        width: mSmallPadding,
                      ),
                      Text(
                        payment.receiptNumber,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: CommonUtil.colorTheme(
                              context,
                              darkColor: mDarkBodyTextColor,
                              lightColor: mLightBodyTextColor,
                            )),
                      ),
                    ],
                  ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
