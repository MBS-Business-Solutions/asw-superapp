import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/contract/down_history_view.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/utils/date_formatter_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_file/open_file.dart';

class ContractDetailView extends StatefulWidget {
  const ContractDetailView({super.key, required this.contractId});
  static const String routeName = '/contract-detail';
  final String contractId;

  @override
  State<ContractDetailView> createState() => _ContractDetailViewState();
}

class _ContractDetailViewState extends State<ContractDetailView> {
  bool _isLoadingContractFile = false;
  late Future<ContractDetail?> _contractDetailFuture;

  @override
  void initState() {
    _contractDetailFuture = context.read<ContractProvider>().fetchContractDetail(widget.contractId);
    super.initState();
  }

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
          future: _contractDetailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final contractDetail = snapshot.data!;
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildDetailText(context, label: AppLocalizations.of(context)!.contractDetailContractDate, value: DateFormatterUtil.formatShortDate(context, contractDetail.date)),
                          _buildDetailText(context, label: AppLocalizations.of(context)!.contractDetailSigningDate, value: DateFormatterUtil.formatShortDate(context, contractDetail.signDate)),
                          _buildDetailText(context,
                              label: AppLocalizations.of(context)!.contractDetailEstimatedTransferDate, value: DateFormatterUtil.formatShortDate(context, contractDetail.transferDate)),
                          const Divider(
                            color: Colors.white10,
                            thickness: 4,
                          ),
                          // มูลค่าสัญญา
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: mMediumPadding, horizontal: mScreenEdgeInsetValue),
                            child: Text(
                              AppLocalizations.of(context)!.contractDetailContractValueTitle,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                          _buildDetailText(context,
                              label: AppLocalizations.of(context)!.contractDetailBookingSellingPrice, value: AppLocalizations.of(context)!.priceFormat(contractDetail.sellingPrice)),
                          _buildDetailText(context,
                              label: AppLocalizations.of(context)!.contractDetailBookingDiscountPrice, value: AppLocalizations.of(context)!.priceFormat(contractDetail.cashDiscount)),
                          _buildDetailText(context, label: AppLocalizations.of(context)!.contractDetailBookingNetPrice, value: AppLocalizations.of(context)!.priceFormat(contractDetail.netPrice)),

                          _buildDetailText(context, label: AppLocalizations.of(context)!.contractDetailBookingAmount, value: AppLocalizations.of(context)!.priceFormat(contractDetail.bookAmount)),
                          _buildDetailText(context, label: AppLocalizations.of(context)!.contractDetailContractAmount, value: AppLocalizations.of(context)!.priceFormat(contractDetail.contractAmount)),
                          _buildDetailText(
                            context,
                            label: AppLocalizations.of(context)!.contractDetailDownAmount,
                            additionalWidget: contractDetail.downAmount <= 0
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context, DownHistoryView.routeName, arguments: {'contractId': widget.contractId});
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.remove_red_eye,
                                              size: 16,
                                              color: mUnPaidColor,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(AppLocalizations.of(context)!.contractDetailDownAmountDetails,
                                                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                      color: mUnPaidColor,
                                                      decorationColor: mUnPaidColor,
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
                            padding: const EdgeInsets.symmetric(vertical: mMediumPadding, horizontal: mScreenEdgeInsetValue),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: mMediumPadding, horizontal: mScreenEdgeInsetValue),
                            child: Text(
                              AppLocalizations.of(context)!.contractDetailFreebiesTitle,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),

                          for (final freebie in contractDetail.freebies ?? [])
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: mMediumPadding, horizontal: mScreenEdgeInsetValue),
                              child: Row(
                                children: [
                                  Text(
                                    '\u2022 ',
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Expanded(
                                    child: Text(
                                      freebie,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.labelMedium,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          SizedBox(height: MediaQuery.of(context).padding.bottom + 64),
                        ],
                      ),
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
                            onPressed: _isLoadingContractFile
                                ? null
                                : () {
                                    _downloadAndOpenPdf(context, widget.contractId);
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(AppLocalizations.of(context)!.contractDetailDownloadDoc),
                                const Icon(Icons.file_download_outlined),
                                if (_isLoadingContractFile) const CircularProgressIndicator.adaptive(),
                              ],
                            ))),
                  ),
                )
              ],
            );
          }),
    );
  }

  Future<void> _downloadAndOpenPdf(BuildContext context, String contractId) async {
    setState(() {
      _isLoadingContractFile = true;
    });
    try {
      // ดาวน์โหลดไฟล์ PDF
      final filePath = await context.read<ContractProvider>().downloadContract(contractId);
      if (filePath != null) {
        // เปิดไฟล์ PDF และให้ผู้ใช้เลือกแอป
        await OpenFile.open(filePath);
      } else {
        // แจ้งเตือนเมื่อไม่สามารถดาวน์โหลดไฟล์ได้
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.errorUnableToDownloadContract),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      if (kDebugMode) print("Error: $e");
    }
    setState(() {
      _isLoadingContractFile = false;
    });
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
