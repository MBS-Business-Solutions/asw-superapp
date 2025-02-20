import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
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
    this.numberOfBackStep = 2,
  });
  static const String routeName = '/qr_view';
  final Contract contract;
  final double amount;
  final int numberOfBackStep;

  @override
  Widget build(BuildContext context) {
    final WidgetsToImageController controller = WidgetsToImageController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(AppLocalizations.of(context)!.qrViewTitle),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: context.read<ContractProvider>().getQRPaymentCode(contractId: contract.contractId, amount: amount),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final qrCode = snapshot.data;
            if (qrCode == null) {
              return const Center(child: Text('Error'));
            }
            return SizedBox(
              height: double.infinity,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                    child: WidgetsToImage(
                      controller: controller,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(mDefaultPadding),
                            color: Theme.of(context).brightness == Brightness.dark ? mDarkCardBackgroundColor : mLightCardBackgroundColor,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('โครงการ', style: Theme.of(context).textTheme.labelMedium),
                                    const Spacer(),
                                    Text(contract.projectName, style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: mMediumPadding),
                                Row(
                                  children: [
                                    Text('แปลง/ห้อง', style: Theme.of(context).textTheme.labelMedium),
                                    const Spacer(),
                                    Text(contract.unitNumber, style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: mMediumPadding),
                                Row(
                                  children: [
                                    Text('ยอดชำระทั้งสิ้น', style: Theme.of(context).textTheme.labelMedium),
                                    const Spacer(),
                                    Text(StringUtil.formatNumber(amount.toString()), style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: mDefaultPadding),
                          Container(
                            padding: const EdgeInsets.all(mDefaultPadding),
                            width: double.infinity,
                            color: Colors.white,
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                QrImageView(
                                  size: MediaQuery.of(context).size.width * 0.6,
                                  data: qrCode,
                                  backgroundColor: Colors.white,
                                ),
                                const SizedBox(
                                  height: mMediumPadding,
                                ),
                                Text(
                                  'ยอดชำระทั้งสิ้น',
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
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.only(left: mScreenEdgeInsetValue, right: mScreenEdgeInsetValue, top: 16, bottom: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? mDarkCardBackgroundColor : mLightCardBackgroundColor,
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
                            child: const Text('ดาวน์โหลด QR Code'),
                          ),
                          FilledButton(
                              onPressed: () {
                                for (var i = 0; i < numberOfBackStep; i++) {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('เสร็จสิ้น')),
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

  Future<void> _saveImage(BuildContext context, WidgetsToImageController controller) async {
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
