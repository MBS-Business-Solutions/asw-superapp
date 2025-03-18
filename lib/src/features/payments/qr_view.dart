import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class QRView extends StatelessWidget {
  const QRView({
    super.key,
    required this.contract,
    required this.amount,
  });
  static const String routeName = '/qr_view';
  final Contract contract;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final WidgetsToImageController controller = WidgetsToImageController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(AppLocalizations.of(context)!.qrViewTitle),
        centerTitle: true,
      ),
      body: FutureBuilder<QRResponse?>(
          future: context.read<ContractProvider>().getQRPaymentCode(contractId: contract.contractId, amount: amount),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final qrCode = snapshot.data;
            if (qrCode == null || qrCode.status != 'success') {
              return const Center(child: Text('Error'));
            }
            return SizedBox(
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetsToImage(
                              controller: controller,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(mDefaultPadding),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Theme.of(context).brightness == Brightness.dark ? mDarkCardBackgroundColor : mLightCardBackgroundColor,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(AppLocalizations.of(context)!.qrViewProject, style: Theme.of(context).textTheme.labelMedium),
                                            const Spacer(),
                                            Text(contract.projectName, style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        const SizedBox(height: mMediumPadding),
                                        Row(
                                          children: [
                                            Text(AppLocalizations.of(context)!.qrViewUnit, style: Theme.of(context).textTheme.labelMedium),
                                            const Spacer(),
                                            Text(contract.unitNumber, style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        const SizedBox(height: mMediumPadding),
                                        Row(
                                          children: [
                                            Text(AppLocalizations.of(context)!.qrViewTotal, style: Theme.of(context).textTheme.labelMedium),
                                            const Spacer(),
                                            Text(StringUtil.formatNumber(amount.toString()), style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: mDefaultPadding * 2),
                                  Container(
                                    padding: const EdgeInsets.all(mDefaultPadding),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    alignment: Alignment.topCenter,
                                    child: Column(
                                      children: [
                                        QrImageView(
                                          size: MediaQuery.of(context).size.width * 0.6,
                                          data: qrCode.qrCode!,
                                          backgroundColor: Colors.white,
                                        ),
                                        const SizedBox(
                                          height: mMediumPadding,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!.qrViewTotal,
                                          style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),
                                        ),
                                        const SizedBox(
                                          height: mMediumPadding,
                                        ),
                                        Text(
                                          StringUtil.formatNumber(amount.toString()),
                                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: mDefaultPadding * 2),
                            Text(
                              AppLocalizations.of(context)!.qrViewPromptPayInstruction,
                              style: Theme.of(context).textTheme.labelLarge,
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: mDefaultPadding),
                            Padding(
                              padding: const EdgeInsets.only(left: mMediumPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.qrViewPromptPayInstruction1,
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  const SizedBox(height: mMediumPadding),
                                  Text(
                                    AppLocalizations.of(context)!.qrViewPromptPayInstruction2,
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  const SizedBox(height: mMediumPadding),
                                  Text(
                                    AppLocalizations.of(context)!.qrViewPromptPayInstruction3,
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  const SizedBox(height: mMediumPadding),
                                  Text(
                                    AppLocalizations.of(context)!.qrViewPromptPayInstruction4,
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  SizedBox(height: MediaQuery.of(context).padding.bottom + 140),
                                ],
                              ),
                            ),
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
                      padding: const EdgeInsets.only(left: mScreenEdgeInsetValue, right: mScreenEdgeInsetValue, top: 16, bottom: 8),
                      decoration: BoxDecoration(
                        color: (Theme.of(context).brightness == Brightness.dark ? mDarkCardBackgroundColor : mLightCardBackgroundColor).withOpacity(0.8),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                      ),
                      child: SafeArea(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FilledButton.tonal(
                            onPressed: () {
                              _saveImage(context, controller);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: mGreyBackgroundColor,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(AppLocalizations.of(context)!.qrViewPromptPayDownload),
                          ),
                          FilledButton(onPressed: () => _doneTap(context), child: Text(AppLocalizations.of(context)!.qrViewPromptPayDone)),
                        ],
                      )),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  void _doneTap(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst || route.settings.name == ContractsView.routeName);
  }

  Future<void> _saveImage(BuildContext context, WidgetsToImageController controller) async {
    if (!await Gal.hasAccess()) {
      Gal.requestAccess();
    } else {
      final bytes = await controller.capture();
      if (bytes != null) {
        await Gal.putImageBytes(bytes, name: DateTime.now().toString(), album: 'AssetWise');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('QR Code saved to gallery'),
          ),
        );
      }
    }
  }
}
