import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/features/contract/down_history_view.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/utils/date_formatter_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContractDetailView extends StatelessWidget {
  const ContractDetailView({super.key, required this.contractId});
  static const String routeName = '/contract-detail';
  final String contractId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.contractDetailTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? mDarkBackgroundColor : mLightBackgroundColor,
      ),
      body: FutureBuilder(
          future: context.read<ContractProvider>().fetchContractDetail(contractId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final contractDetail = snapshot.data!;
            return Stack(
              children: [
                SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailText(context, label: AppLocalizations.of(context)!.contractDetailContractDate, value: DateFormatterUtil.format(context, contractDetail.date)),
                        _buildDetailText(context, label: AppLocalizations.of(context)!.contractDetailSigningDate, value: DateFormatterUtil.format(context, contractDetail.signDate)),
                        _buildDetailText(context, label: AppLocalizations.of(context)!.contractDetailEstimatedTransferDate, value: DateFormatterUtil.format(context, contractDetail.transferDate)),
                        const Divider(
                          color: Colors.white10,
                          thickness: 4,
                        ),
                        // มูลค่าสัญญา
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                          child: Text(
                            AppLocalizations.of(context)!.contractDetailContractValueTitle,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        _buildDetailText(context, label: AppLocalizations.of(context)!.contractDetailBookingAmount, value: AppLocalizations.of(context)!.priceFormat(contractDetail.bookAmount)),
                        _buildDetailText(context, label: AppLocalizations.of(context)!.contractDetailContractAmount, value: AppLocalizations.of(context)!.priceFormat(contractDetail.contractAmount)),
                        _buildDetailText(
                          context,
                          label: AppLocalizations.of(context)!.contractDetailDownAmount,
                          additionalWidget: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, DownHistoryView.routeName);
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.remove_red_eye,
                                      size: 16,
                                      color: mBrightPrimaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(AppLocalizations.of(context)!.contractDetailDownAmountDetails,
                                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                              color: mBrightPrimaryColor,
                                              decorationColor: mBrightPrimaryColor,
                                              decoration: TextDecoration.underline,
                                            )),
                                  ],
                                )),
                          ),
                          value: AppLocalizations.of(context)!.priceFormat(contractDetail.downAmount),
                        ),
                        _buildDetailText(context, label: AppLocalizations.of(context)!.contractDetailTransferAmount, value: AppLocalizations.of(context)!.priceFormat(contractDetail.transferAmount)),
                        const Divider(
                          color: Colors.white10,
                          thickness: 4,
                        ),
                        // รายละเอียดการชำระเงิน
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                          child: Text(
                            AppLocalizations.of(context)!.contractDetailPaymentTitle,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        _buildDetailText(context, label: AppLocalizations.of(context)!.contractDetailPaymentAmount, value: AppLocalizations.of(context)!.priceFormat(contractDetail.paymentAmount)),
                        _buildDetailText(context, label: AppLocalizations.of(context)!.contractDetailRemainDownAmount, value: AppLocalizations.of(context)!.priceFormat(contractDetail.remainAmount)),
                        _buildDetailText(context,
                            label: AppLocalizations.of(context)!.contractDetailRemainHousePayment, value: AppLocalizations.of(context)!.priceFormat(contractDetail.remainDownAmount)),
                        const Divider(
                          color: Colors.white10,
                          thickness: 4,
                        ),
                        // รายการของแถมและส่วนลด
                        if (true)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.contractDetailFreebiesTitle,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  child: Text(
                                    '\u2022 Air Daikin 12000 BTU x 2 เครื่อง',
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                ),
                                for (var i = 0; i < 15; i++)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                    child: Text(
                                      '\u2022 Samsung TV LED 40" x 1 เครื่อง',
                                      style: Theme.of(context).textTheme.labelMedium,
                                    ),
                                  ),
                                SizedBox(height: MediaQuery.of(context).padding.bottom + 64),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                    ),
                    child: SafeArea(
                        child: FilledButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(AppLocalizations.of(context)!.contractDetailDownloadDoc), const Icon(Icons.file_download_outlined)],
                            ))),
                  ),
                )
              ],
            );
          }),
    );
  }

  Widget _buildDetailText(BuildContext context, {required String label, Widget? additionalWidget, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              if (additionalWidget != null) additionalWidget,
            ],
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
