import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/contract/receipt_view_file.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/utils/date_formatter_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ReceiptView extends StatefulWidget {
  const ReceiptView({super.key, required this.contractNumber, required this.receiptNumber});
  static const String routeName = '/view-receipt';
  final String contractNumber;
  final String receiptNumber;
  @override
  State<ReceiptView> createState() => _ReceiptViewState();
}

class _ReceiptViewState extends State<ReceiptView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommonUtil.dismissKeyboard(context),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(AppLocalizations.of(context)!.receiptViewTitle),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: context.read<ContractProvider>().getReceiptDetail(widget.contractNumber, widget.receiptNumber),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final receiptDetail = snapshot.data;
              if (receiptDetail == null) {
                return Center(child: Text(AppLocalizations.of(context)!.errorNoData));
              }
              return Stack(
                children: [
                  const AssetWiseBG(),
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/ASW_Logo_Rac_dark-bg.svg',
                      width: MediaQuery.of(context).size.width,
                      colorFilter: const ColorFilter.mode(Colors.white12, BlendMode.srcIn),
                    ),
                  ),
                  SafeArea(
                      child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Center(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/images/payment_success.svg',
                            ),
                            const SizedBox(height: mDefaultPadding),
                            Text(AppLocalizations.of(context)!.receiptViewSuccess,
                                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                      color: CommonUtil.colorTheme(context, darkColor: mDarkPaidColor, lightColor: mLightPaidColor),
                                    )),
                            const SizedBox(height: mMediumPadding),
                            Text(AppLocalizations.of(context)!.priceFormatDouble(receiptDetail.amount),
                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                      color: CommonUtil.colorTheme(
                                        context,
                                        darkColor: mDarkBodyTextColor,
                                        lightColor: mLightBodyTextColor,
                                      ),
                                    )),
                            const SizedBox(height: mMediumPadding),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.receipt_long_sharp, size: 18),
                                Text(widget.receiptNumber, style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ],
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  AppLocalizations.of(context)!.receiptViewPaymentType,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                )),
                                Text(receiptDetail.paymentType),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  AppLocalizations.of(context)!.receiptViewDate,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                )),
                                Text(DateFormatterUtil.formatShortDate(context, receiptDetail.date)),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  AppLocalizations.of(context)!.receiptViewRef1,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                )),
                                Text(receiptDetail.ref1),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  AppLocalizations.of(context)!.receiptViewRef2,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                )),
                                Text(receiptDetail.ref2),
                              ],
                            ),
                            const SizedBox(
                              height: mDefaultPadding * 2,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  AppLocalizations.of(context)!.receiptViewRemark,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  AppLocalizations.of(context)!.receiptViewDue,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                )),
                                Text(DateFormatterUtil.formatShortDate(context, receiptDetail.dueDate)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                        child: FilledButton(
                            onPressed: () => Navigator.pushNamed(context, ReceiptViewFile.routeName, arguments: {'contractNumber': widget.contractNumber, 'receiptNumber': widget.receiptNumber}),
                            child: Text(
                              AppLocalizations.of(context)!.receiptViewViewReceipt,
                            )),
                      ),
                      const SizedBox(height: mDefaultPadding),
                    ],
                  )),
                ],
              );
            }),
      ),
    );
  }
}
