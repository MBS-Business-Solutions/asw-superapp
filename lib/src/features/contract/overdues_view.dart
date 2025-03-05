import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/contract/widgets/down_term_due_tile.dart';
import 'package:AssetWise/src/features/payments/payment_channels_view.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OverduesView extends StatefulWidget {
  const OverduesView({super.key, required this.contract});
  static const String routeName = '/overdues';
  final Contract contract;

  @override
  State<OverduesView> createState() => _OverduesViewState();
}

class _OverduesViewState extends State<OverduesView> {
  final _selectedDownPaymentTermDue = <DownPaymentTermDue>{};
  int _payAmount = 0;
  final List<DownPaymentTermDue> downTermDues = [];

  @override
  void initState() {
    init();

    super.initState();
  }

  void init() async {
    final dues = await context.read<ContractProvider>().fetchDownPaymentTermDues(widget.contract.contractId);
    if (dues == null) return;
    setState(() {
      downTermDues.addAll(dues);
      for (final due in dues) {
        _selectedDownPaymentTermDue.add(due);
      }
      _payAmount = _selectedDownPaymentTermDue.fold(0, (sum, item) => sum + item.amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.overduesViewTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? mDarkBackgroundColor : mLightBackgroundColor,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    if (downTermDues.isEmpty) return const SizedBox();
                    if (index == downTermDues.length) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.overduesViewSumLabel,
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: CommonUtil.colorTheme(context, darkColor: mDarkUnPaidColor, lightColor: mLightUnPaidColor)),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.priceFormatDouble(_payAmount),
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: CommonUtil.colorTheme(context, darkColor: mDarkUnPaidColor, lightColor: mLightUnPaidColor)),
                            ),
                          ],
                        ),
                      );
                    }
                    return DownPaymentTermDueTile(
                      canChange: (due, tobeValue) {
                        final previousDue = (index - 1) < 0 ? null : downTermDues[index - 1];
                        final nextDue = (index + 1) >= downTermDues.length ? null : downTermDues[index + 1];
                        if (tobeValue) {
                          // user selected this due
                          return previousDue == null || _selectedDownPaymentTermDue.contains(previousDue);
                        } else {
                          // user unselected this due
                          return nextDue == null || !_selectedDownPaymentTermDue.contains(nextDue);
                        }
                      },
                      onTap: (value) {
                        setState(() {
                          if (!value) {
                            _selectedDownPaymentTermDue.remove(downTermDues[index]);
                          } else {
                            _selectedDownPaymentTermDue.add(downTermDues[index]);
                          }
                          _payAmount = _selectedDownPaymentTermDue.fold(0, (sum, item) => sum + item.amount);
                        });
                      },
                      termDue: downTermDues[index],
                      initial: true,
                    );
                  },
                  itemCount: downTermDues.length + 1,
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
                  child: FilledButton(
                    onPressed: _payAmount > 0
                        ? () {
                            Navigator.pushNamed(context, PaymentChannelsView.routeName, arguments: {
                              'contract': widget.contract,
                              'amount': _payAmount.toDouble(),
                            });
                            // Navigator.push(context, MaterialPageRoute(builder: (context) {
                            // }));
                          }
                        : null,
                    child: Text(AppLocalizations.of(context)!.overduesViewMakePayment),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
