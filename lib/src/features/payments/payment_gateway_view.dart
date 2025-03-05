import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentGatewayView extends StatefulWidget {
  const PaymentGatewayView({super.key, required this.contract, required this.amount, this.detail});
  static const String routeName = '/payment-gateway';
  final Contract contract;
  final double amount;
  final String? detail;

  @override
  State<PaymentGatewayView> createState() => _PaymentGatewayViewState();
}

class _PaymentGatewayViewState extends State<PaymentGatewayView> {
  late final WebViewController _controller;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {},
      ));
    final userEmail = context.read<UserProvider>().userInformation?.email ?? '';
    final url = await context.read<ContractProvider>().getPaymentGatewayURL(
          contract: widget.contract,
          amount: widget.amount,
          detail: widget.detail,
          email: userEmail,
        );
    if (url == null) {
      Navigator.of(context).pop();
      return;
    }
    _controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ชำระเงิน'),
          centerTitle: true,
          leading: const SizedBox(),
          actions: [
            IconButton(
              onPressed: () => Navigator.popUntil(context, ModalRoute.withName(ContractsView.routeName)),
              icon: const Icon(Icons.close),
            )
          ],
        ),
        body: WebViewWidget(controller: _controller));
  }
}
