import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/services/aw_contract_service.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReceiptViewFile extends StatefulWidget {
  const ReceiptViewFile({super.key, required this.contractNumber, required this.receiptNumber});
  static const String routeName = '/view-receipt-file';
  final String contractNumber;
  final String receiptNumber;
  @override
  State<ReceiptViewFile> createState() => _ReceiptViewFileState();
}

class _ReceiptViewFileState extends State<ReceiptViewFile> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          setState(() {
            _isLoading = false;
          });
        },
      ))
      ..loadRequest(Uri.parse(AwContractService.getViewReceiptURL(widget.contractNumber, widget.receiptNumber)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(AppLocalizations.of(context)!.receiptViewFileTitle),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            const AssetWiseBG(),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            Offstage(
              offstage: _isLoading,
              child: SafeArea(
                  child: Column(
                children: [
                  Expanded(child: WebViewWidget(controller: _controller)),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue, vertical: mDefaultPadding),
                    child: FilledButton(
                        onPressed: () {
                          const url = 'https://superapp-api.azurewebsites.net/mobile/contracts/SO-EQC019-19040123/payments/RV-EQC019-19100156/download';
                        },
                        child: Text(
                          AppLocalizations.of(context)!.receiptViewFileDownload,
                        )),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
