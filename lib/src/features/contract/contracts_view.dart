import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/features/contract/contract_detail_view.dart';
import 'package:AssetWise/src/features/contract/receipt/receipt_view.dart';
import 'package:AssetWise/src/features/contract/widgets/history_list_tile.dart';
import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContractsView extends StatefulWidget {
  const ContractsView({super.key});
  static const String routeName = '/contracts';

  @override
  State<ContractsView> createState() => _ContractsViewState();
}

class _ContractsViewState extends State<ContractsView> {
  String? _selectedContract;
  int _selectedIndex = 0;
  int _selectedYear = DateTime.now().year;
  late SupportedLocales _selectedLocale;
  List<Contract>? _contracts;

  @override
  void initState() {
    _initialLoad();
    _selectedLocale = context.read<SettingsController>().supportedLocales;
    super.initState();
  }

  void _initialLoad() async {
    final contracts = await context.read<ContractProvider>().fetchContracts();
    if (contracts.isNotEmpty) {
      setState(() {
        _contracts = contracts;
        _selectedContract = contracts.first.contractId;
        _selectedYear = DateTime.now().year;
      });
    }
  }

  List<int> _selectableYears() {
    final currentYear = DateTime.now().year;
    return List.generate(3, (index) => currentYear - index);
  }

  void _onContractSelected(String contractId) {
    setState(() {
      _selectedContract = contractId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _contracts == null
              ? const Center(child: SizedBox())
              : Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  padding: const EdgeInsets.only(bottom: 32),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: NetworkImage(_contracts![_selectedIndex].imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                  )),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _selectedIndex > 0
                            ? () {
                                setState(() {
                                  _selectedIndex--;
                                  _onContractSelected(_contracts![_selectedIndex].contractId);
                                });
                              }
                            : null,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Expanded(child: SizedBox()),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_contracts![_selectedIndex].unitNumber, style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white)),
                                Text(_contracts![_selectedIndex].projectName, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white)),
                              ],
                            ),
                            Expanded(
                                child: Center(
                                    child: OutlinedButton.icon(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContractDetailView(
                                            contractId: _selectedContract!,
                                          ))),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.dock_sharp),
                              label: Text(AppLocalizations.of(context)!.contractsViewContract),
                            ))),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _selectedIndex < _contracts!.length - 1
                            ? () {
                                setState(() {
                                  _selectedIndex++;
                                  _onContractSelected(_contracts![_selectedIndex].contractId);
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: (MediaQuery.of(context).size.height * 0.65) + 32,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(32)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white10,
                    spreadRadius: 0,
                    blurRadius: 15,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomScrollView(
                slivers: [
                  if (_selectedContract != null)
                    FutureBuilder(
                        future: context.read<ContractProvider>().fetchOverdueDetail(_selectedContract!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SliverFillRemaining(child: Center(child: CircularProgressIndicator.adaptive()));
                          }
                          final overdueDetail = snapshot.data;
                          return SliverToBoxAdapter(
                            child: overdueDetail == null
                                ? const SizedBox()
                                : Container(
                                    margin: const EdgeInsets.only(top: 24),
                                    padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                      border: Border.all(color: const Color(0xFF585858)),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(32),
                                        topRight: Radius.circular(32),
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.2),
                                          spreadRadius: 0,
                                          blurRadius: 5,
                                          offset: const Offset(0, -1),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(AppLocalizations.of(context)!.overdueDetailAmountLabel, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: mBrightPrimaryColor)),
                                            Text(AppLocalizations.of(context)!.priceFormatBaht(overdueDetail.amount),
                                                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: mBrightPrimaryColor)),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(AppLocalizations.of(context)!.overdueDetailDueDateLabel, style: Theme.of(context).textTheme.bodyMedium),
                                            Text('25 ธ.ค. 67', style: Theme.of(context).textTheme.bodyMedium),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(AppLocalizations.of(context)!.overdueDetailCreditNumberLabel, style: Theme.of(context).textTheme.bodyMedium),
                                            Text('*1234', style: Theme.of(context).textTheme.bodyMedium),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(AppLocalizations.of(context)!.overdueDetailDeditDateLabel, style: Theme.of(context).textTheme.bodyMedium),
                                            Text('25 ธ.ค. 67', style: Theme.of(context).textTheme.bodyMedium),
                                          ],
                                        ),
                                        FilledButton(onPressed: () {}, child: Text(AppLocalizations.of(context)!.overdueDetailPayment)),
                                        TextButton(
                                            onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ContractDetailView(
                                                          contractId: _selectedContract!,
                                                        ))),
                                            style: TextButton.styleFrom(foregroundColor: Colors.white),
                                            child: Text(AppLocalizations.of(context)!.overdueDetailViewDetail)),
                                      ],
                                    ),
                                  ),
                          );
                        }),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Expanded(child: Text(AppLocalizations.of(context)!.paymentHistoryTitle, style: Theme.of(context).textTheme.titleMedium)),
                          Container(
                            padding: const EdgeInsets.only(left: 16, right: 4, top: 4, bottom: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.all(Radius.circular(32)),
                              border: Border.all(color: const Color(0xFF585858)),
                            ),
                            child: DropdownButton<int>(
                              isDense: true,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              style: Theme.of(context).textTheme.labelMedium,
                              underline: const SizedBox(),
                              value: _selectedYear,
                              items: _selectableYears().map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(_selectedLocale == SupportedLocales.th ? '${value + 543}' : '$value'),
                                );
                              }).toList(),
                              onChanged: (int? newValue) {
                                setState(() {
                                  _selectedYear = newValue!;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (_selectedContract != null)
                    FutureBuilder(
                        future: context.read<ContractProvider>().fetchPaymentsByYear(_selectedContract!, _selectedYear),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SliverFillRemaining(child: Center(child: CircularProgressIndicator.adaptive()));
                          }
                          final payments = snapshot.data;
                          return SliverList(
                              delegate: SliverChildBuilderDelegate((context, index) {
                            return HistoryListTile(
                              paymentDetail: payments![index],
                              selectedLocale: _selectedLocale,
                              onTap: payments[index].status == 'รอยืนยันเงิน' ? null : () => _viewReceipt(payments[index].receiptNumber),
                            );
                          }, childCount: payments?.length));
                        })
                ],
              )),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    ));
  }

  void _viewReceipt(String receiptNumber) {
    Navigator.pushNamed(context, ReceiptView.routeName, arguments: {
      'contractNumber': _selectedContract,
      'receiptNumber': receiptNumber,
    });
  }
}
