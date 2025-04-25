import 'dart:async';

import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanQrView extends StatefulWidget {
  const ScanQrView({super.key});

  @override
  State<ScanQrView> createState() => _ScanQrViewState();
}

class _ScanQrViewState extends State<ScanQrView> with WidgetsBindingObserver {
  StreamSubscription<Object?>? _subscription;
  final _mobileScannerController = MobileScannerController();
  String? _qrCodeData;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!_mobileScannerController.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        _subscription = _mobileScannerController.barcodes.listen(_handleBarcode);

        unawaited(_mobileScannerController.start());
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(_mobileScannerController.stop());
    }
  }

  void _handleBarcode(BarcodeCapture barcode) {
    if (barcode.barcodes.isEmpty) return;
    final firstCode = barcode.barcodes.first;
    if (firstCode.rawValue == null) return;
    final String code = firstCode.rawValue!;
    if (Uri.tryParse(code) != null) {
      // Handle the scanned QR code here
      setState(() {
        _qrCodeData = code;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = _mobileScannerController.barcodes.listen(_handleBarcode);

    // Finally, start the scanner itself.
    //unawaited(_mobileScannerController.start());
  }

  @override
  Future<void> dispose() async {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    await _mobileScannerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _mobileScannerController,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black38,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 64),
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          Text(
                            'สแกน QR Code',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 100),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/cross_hair.svg',
                                width: MediaQuery.of(context).size.width * 0.8,
                              ),
                              if (_qrCodeData != null)
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      _openLink();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(mSmallPadding),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.link_sharp, color: Color(0xFF0080DD)),
                                          const SizedBox(width: mSmallPadding),
                                          Text(
                                            _qrCodeData!,
                                            maxLines: 2,
                                            overflow: TextOverflow.fade,
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Color(0xFF0080DD)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _openLink() async {
    final uri = Uri.tryParse(_qrCodeData ?? '');
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      Navigator.of(context).pop();
    }
  }
}
