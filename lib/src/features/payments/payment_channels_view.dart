import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/features/notifications/notifications_view.dart';
import 'package:AssetWise/src/features/payments/payment_gateway_view.dart';
import 'package:AssetWise/src/features/payments/qr_view.dart';
import 'package:AssetWise/src/features/payments/unable_to_payment_view.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/utils/date_formatter_util.dart';
import 'package:AssetWise/src/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';
import 'package:provider/provider.dart';

class PaymentChannelsView extends StatefulWidget {
  const PaymentChannelsView({super.key, required this.contract, this.overdueDetail, this.amount});
  static const String routeName = '/payment_channels';
  final Contract contract;
  final OverdueDetail? overdueDetail;
  final double? amount;

  @override
  State<PaymentChannelsView> createState() => _PaymentChannelsViewState();
}

class _PaymentChannelsViewState extends State<PaymentChannelsView> {
  String? _paymentChannel;
  final TextEditingController _amountController = TextEditingController();
  bool _hideButton = false;
  bool _isLoading = false;

  @override
  void initState() {
    if (widget.overdueDetail != null) {
      _amountController.text = StringUtil.formatNumber(widget.overdueDetail!.amount.toString());
    }
    if (widget.amount != null) {
      _amountController.text = StringUtil.formatNumber(widget.amount.toString());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommonUtil.dismissKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(AppLocalizations.of(context)!.paymentChannelViewPaymentTitle),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            ListView(children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? mDarkCardBackgroundColor : mLightCardBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: CommonUtil.colorTheme(context, darkColor: Colors.transparent, lightColor: Colors.black.withOpacity(0.1)),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: ListTile(
                    onTap: () => setState(() {
                          _paymentChannel = 'card';
                        }),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.paymentChannelViewCreditChannel,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 'card',
                              groupValue: _paymentChannel,
                              onChanged: (value) {
                                setState(() {
                                  _paymentChannel = value;
                                });
                              },
                            ),
                            Image.asset(
                              'assets/images/visa_pos_fc.png',
                              height: 24,
                            ),
                            Image.asset(
                              'assets/images/mc_symbol_opt_73.png',
                              height: 24,
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                height: mMediumPadding,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? mDarkCardBackgroundColor : mLightCardBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: CommonUtil.colorTheme(context, darkColor: Colors.transparent, lightColor: Colors.black.withOpacity(0.1)),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: ListTile(
                    onTap: () => setState(() {
                          _paymentChannel = 'qr';
                        }),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.paymentChannelViewQRChannel,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 'qr',
                              groupValue: _paymentChannel,
                              onChanged: (value) {
                                setState(() {
                                  _paymentChannel = value;
                                });
                              },
                            ),
                            Text(AppLocalizations.of(context)!.paymentChannelViewQRChannel),
                          ],
                        )
                      ],
                    )),
              ),
            ]),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(left: mScreenEdgeInsetValue, right: mScreenEdgeInsetValue, top: 16, bottom: 8),
                decoration: BoxDecoration(
                  color: CommonUtil.colorTheme(context, darkColor: mDarkCardBackgroundColor, lightColor: mLightCardBackgroundColor),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: CommonUtil.colorTheme(context, darkColor: Colors.transparent, lightColor: Colors.black.withOpacity(0.1)),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.paymentChannelViewTotalAmount,
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: CommonUtil.colorTheme(context, darkColor: mBrightPrimaryColor, lightColor: mPrimaryMatColor)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                margin: const EdgeInsets.only(left: mDefaultPadding),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: CommonUtil.colorTheme(context, darkColor: mGreyBackgroundColor, lightColor: mLightBackgroundColor),
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                                ),
                                child: TextField(
                                  controller: _amountController,
                                  textAlign: TextAlign.end,
                                  keyboardAppearance: Theme.of(context).brightness,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  onTapOutside: (event) {
                                    if (_amountController.text.isNotEmpty) _amountController.text = StringUtil.formatNumber(_amountController.text);
                                    setState(() {
                                      _hideButton = false;
                                    });
                                  },
                                  onSubmitted: (value) {
                                    if (_amountController.text.isNotEmpty) _amountController.text = StringUtil.formatNumber(_amountController.text);
                                    setState(() {
                                      _hideButton = false;
                                    });
                                  },
                                  onTap: () {
                                    setState(() {
                                      _hideButton = true;
                                    });
                                    var text = StringUtil.removeSymbol(_amountController.text);
                                    _amountController.text = text.endsWith(".00") ? text.substring(0, text.length - 3) : text;
                                  },
                                  decoration: InputDecoration(
                                    hintText: '0.00',
                                    hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: mGreyColor),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: CommonUtil.colorTheme(context, darkColor: mBrightPrimaryColor, lightColor: mPrimaryMatColor)),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 2),
                              padding: const EdgeInsets.symmetric(horizontal: mMediumPadding),
                              decoration: BoxDecoration(
                                color: CommonUtil.colorTheme(context, darkColor: mGreyBackgroundColor, lightColor: mLightBackgroundColor),
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)!.bahtUnit,
                                style: Theme.of(context).textTheme.labelLarge!.copyWith(color: mGreyColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: mMediumPadding),
                      if (widget.overdueDetail != null) ...[
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.paymentChannelViewDue,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const Spacer(),
                            Text(
                              DateFormatterUtil.formatShortDate(context, widget.overdueDetail!.dueDate),
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: mDefaultPadding),
                      ],
                      FilledButton.icon(
                        onPressed: _canPay() ? () => _onPayTap() : null,
                        icon: _isLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator()) : null,
                        label: Text(AppLocalizations.of(context)!.paymentChannelViewPayment),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool _canPay() {
    if (_isLoading) return false;
    return !_hideButton && _paymentChannel != null && _amountController.text.isNotEmpty;
  }

  void _onPayTap() async {
    setState(() {
      _isLoading = true;
    });
    final amount = double.parse(StringUtil.removeSymbol(_amountController.text));
    if (_paymentChannel == 'qr') {
      // test before push
      final qrResponse = await context.read<ContractProvider>().getQRPaymentCode(contractId: widget.contract.contractId, amount: amount);
      if (qrResponse == null || qrResponse.status != 'success') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => UnableToPaymentView(
              reason: qrResponse?.message ?? AppLocalizations.of(context)!.errorUnableToProcess,
            ),
          ),
          (route) => route.isFirst || route.settings.name == ContractsView.routeName || route.settings.name == NotificationsView.routeName,
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QRView(
                    contract: widget.contract,
                    amount: amount,
                  )),
        );
      }
    } else if (_paymentChannel == 'card') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentGatewayView(
              amount: amount,
              contract: widget.contract,
              detail: widget.contract.unitNumber,
            ),
          ));
    }
    setState(() {
      _isLoading = false;
    });
  }
}
