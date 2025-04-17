import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gal/gal.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class MyQrView extends StatelessWidget {
  const MyQrView({super.key});
  static const String routeName = '/my_qr';

  @override
  Widget build(BuildContext context) {
    final WidgetsToImageController controller = WidgetsToImageController();
    final userProvider = context.read<UserProvider>();
    return Stack(
      children: [
        const AssetWiseBG(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.myQRTitle,
            ),
            backgroundColor: Colors.transparent,
            centerTitle: true,
          ),
          body: FutureBuilder(
              future: userProvider.fetchMyQR(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final qrData = snapshot.data;
                if (qrData == null) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.errorUnableToProcess,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }
                return Column(
                  children: [
                    WidgetsToImage(
                      controller: controller,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                        padding: const EdgeInsets.all(mDefaultPadding),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            QrImageView(
                              size: MediaQuery.of(context).size.width * 0.6,
                              data: qrData.qrCode ?? '',
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: Colors.white,
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: mMediumPadding,
                            ),
                            Text(
                              AppLocalizations.of(context)!.myQRDescription,
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),
                            ),
                            const SizedBox(
                              height: mMediumPadding,
                            ),
                            Text(
                              AppLocalizations.of(context)!.myQRRefCode(qrData.ref ?? ''),
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: mDefaultPadding * 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(mSmallPadding),
                              alignment: Alignment.center,
                              width: 80,
                              child: Column(
                                children: [
                                  Icon(Icons.document_scanner_outlined),
                                  Text(AppLocalizations.of(context)!.myQRScanQR),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => _share(context, controller),
                            child: Container(
                              padding: const EdgeInsets.all(mSmallPadding),
                              alignment: Alignment.center,
                              width: 80,
                              child: Column(
                                children: [
                                  Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                                    child: Icon(Icons.reply),
                                  ),
                                  Text(AppLocalizations.of(context)!.myQRShare),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => _saveImage(context, controller),
                            child: Container(
                              padding: const EdgeInsets.all(mSmallPadding),
                              alignment: Alignment.center,
                              width: 80,
                              child: Column(
                                children: [
                                  Icon(Icons.file_download_outlined),
                                  Text(AppLocalizations.of(context)!.myQRSave),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }),
        ),
      ],
    );
  }

  Future<void> _saveImage(BuildContext context, WidgetsToImageController controller) async {
    if (!await Gal.hasAccess()) {
      Gal.requestAccess();
    } else {
      final bytes = await controller.capture();
      if (bytes != null) {
        await Gal.putImageBytes(bytes, name: DateTime.now().toString(), album: 'AssetWise');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.grey[850],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            showCloseIcon: true,
            closeIconColor: Colors.white,
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.myQRSaveCompleted,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  Future<void> _share(BuildContext context, WidgetsToImageController controller) async {
    final bytes = await controller.capture();
    if (bytes == null) return;

    final box = context.findRenderObject() as RenderBox?;
    await Share.shareXFiles(
      [XFile.fromData(bytes, mimeType: 'image/png', name: DateTime.now().toString())],
      text: AppLocalizations.of(context)!.myQRTitle,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}
