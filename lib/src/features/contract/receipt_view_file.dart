import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/services/aw_contract_service.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
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
  bool _isDownloading = false;

  @override
  void initState() {
    final url = AwContractService.getViewReceiptURL(widget.contractNumber, widget.receiptNumber);
    // final url = "https://superapp-api.azurewebsites.net/";
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          setState(() {
            _isLoading = false;
          });
        },
      ))
      ..loadRequest(Uri.parse(url));
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
                    child: FilledButton.icon(
                        onPressed: _isDownloading ? null : () => _downloadReceiptFile(),
                        icon: _isDownloading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator()) : null,
                        label: Text(
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

  Future<void> _downloadReceiptFile() async {
    setState(() {
      _isDownloading = true;
    });
    // ดาวน์โหลดไฟล์ PDF
    final filePath = await context.read<ContractProvider>().downloadReceipt(widget.contractNumber, widget.receiptNumber, widget.receiptNumber);
    if (filePath != null) {
      // เปิดไฟล์ PDF และให้ผู้ใช้เลือกแอป

      await Share.shareXFiles([XFile(filePath)]);
      //await OpenFile.open(filePath);
    } else {
      // แจ้งเตือนเมื่อไม่สามารถดาวน์โหลดไฟล์ได้
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          AppLocalizations.of(context)!.errorUnableToProcess,
        ),
      ));
    }
    setState(() {
      _isDownloading = false;
    });
  }
}
