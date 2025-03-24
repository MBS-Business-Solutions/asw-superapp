import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/features/notifications/notifications_view.dart';
import 'package:AssetWise/src/features/payments/unable_to_payment_view.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final response = await context.read<ContractProvider>().getPaymentGatewayURL(
          contract: widget.contract,
          amount: widget.amount,
          detail: widget.detail,
          email: userEmail,
        );
    if (response?.status != 'success') {
      String? reason = response?.message;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => UnableToPaymentView(
                  reason: reason ?? AppLocalizations.of(context)!.errorUnableToProcess,
                )),
        (route) => route.isFirst || route.settings.name == ContractsView.routeName || route.settings.name == NotificationsView.routeName,
      );
      return;
    }
    _controller.loadRequest(Uri.parse(response?.paymentUrl ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.paymentChannelViewPaymentTitle),
          centerTitle: true,
          leading: const SizedBox(),
          actions: [
            IconButton(
              onPressed: () => _doneTap(context),
              icon: const Icon(Icons.close),
            )
          ],
        ),
        body: WebViewWidget(controller: _controller));
  }

  void _doneTap(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst || route.settings.name == ContractsView.routeName || route.settings.name == NotificationsView.routeName);
  }
}
