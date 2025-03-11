import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/contract/contract_detail_view.dart';
import 'package:AssetWise/src/features/contract/overdues_view.dart';
import 'package:AssetWise/src/features/contract/receipt_view.dart';
import 'package:AssetWise/src/features/contract/widgets/history_list_tile.dart';
import 'package:AssetWise/src/features/payments/payment_channels_view.dart';
import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/utils/date_formatter_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContractsView extends StatefulWidget {
  const ContractsView({super.key, this.linkId});
  static const String routeName = '/contracts';
  final String? linkId;

  @override
  State<ContractsView> createState() => _ContractsViewState();
}

class _ContractsViewState extends State<ContractsView> {
  Contract? _selectedContract;
  int _selectedIndex = 0;
  int _selectedYear = DateTime.now().year;
  late SupportedLocales _selectedLocale;
  List<Contract>? _contracts;
  Future<OverdueDetail?>? _fetchOverdueDetail;
  @override
  void initState() {
    _initialLoad();
    _selectedLocale = context.read<SettingsController>().supportedLocales;

    super.initState();
  }

  void _initialLoad() async {
    final contracts = await context.read<ContractProvider>().fetchContracts(null);

    if (contracts.isNotEmpty) {
      setState(() {
        _contracts = contracts;
        _selectedYear = DateTime.now().year;

        _selectedIndex = contracts.indexWhere((element) => element.contractId == widget.linkId);
        if (_selectedIndex < 0) {
          _selectedIndex = 0;
        }
        _selectedContract = contracts[_selectedIndex];
        if (_selectedContract != null) {
          _fetchOverdueDetail = _fetchOverdueDetail ?? context.read<ContractProvider>().fetchOverdueDetail(_selectedContract!.contractId);
        }
      });
    }
  }

  List<int> _selectableYears() {
    final currentYear = DateTime.now().year;
    return List.generate(3, (index) => currentYear - index);
  }

  void _onContractSelected(Contract contract) {
    setState(() {
      _selectedContract = contract;
      _fetchOverdueDetail = context.read<ContractProvider>().fetchOverdueDetail(_selectedContract!.contractId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        if (_contracts != null && _contracts!.isNotEmpty)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _contracts == null ? const Center(child: CircularProgressIndicator()) : _buildContractSelector(context),
          ),
        if (_contracts != null && _contracts!.isNotEmpty)
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
                padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                child: _selectedContract == null
                    ? const SizedBox()
                    : CustomScrollView(
                        slivers: [
                          _buildOverdueSection(),
                          ..._buildPaymentHistories(context),
                          SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.bottom)),
                        ],
                      )),
          ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: mDarkBodyTextColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    ));
  }

  /// Builds a contract selector widget.
  ///
  /// This widget is a `GestureDetector` that allows users to select a contract.
  ///
  /// The [context] parameter is the `BuildContext` in which the widget is built.
  ///
  /// Returns a `GestureDetector` widget.
  GestureDetector _buildContractSelector(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0 && _selectedIndex < _contracts!.length - 1) {
          setState(() {
            _selectedIndex++;
            _onContractSelected(_contracts![_selectedIndex]);
          });
        } else if (details.primaryVelocity! > 0 && _selectedIndex > 0) {
          setState(() {
            _selectedIndex--;
            _onContractSelected(_contracts![_selectedIndex]);
          });
        }
      },
      child: Container(
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
              icon: const Icon(
                Icons.chevron_left,
                // color: mDarkBodyTextColor,
              ),
              onPressed: _selectedIndex > 0
                  ? () {
                      setState(() {
                        _selectedIndex--;
                        _onContractSelected(_contracts![_selectedIndex]);
                      });
                    }
                  : null,
              color: mDarkBodyTextColor,
            ),
            Expanded(
              child: Column(
                children: [
                  const Expanded(child: SizedBox()),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_contracts![_selectedIndex].unitNumber, style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: mDarkBodyTextColor)),
                      Text(_contracts![_selectedIndex].projectName, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: mDarkBodyTextColor)),
                    ],
                  ),
                  Expanded(
                    child: _contracts![_selectedIndex].isResident
                        ? Center(
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContractDetailView(
                                            contractId: _selectedContract!.contractId,
                                          ))),
                              icon: const Icon(Icons.dock_sharp),
                              label: Text(AppLocalizations.of(context)!.contractsViewContract),
                            ),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.chevron_right,
                // color: mDarkBodyTextColor,
              ),
              onPressed: _selectedIndex < _contracts!.length - 1
                  ? () {
                      setState(() {
                        _selectedIndex++;
                        _onContractSelected(_contracts![_selectedIndex]);
                      });
                    }
                  : null,
              color: mDarkBodyTextColor,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a FutureBuilder widget that fetches and displays the overdue section details.
  ///
  /// This method returns a FutureBuilder that asynchronously fetches the overdue details
  /// and displays them in the UI. The FutureBuilder handles the loading, success, and error
  /// states of the asynchronous operation.
  ///
  /// Returns:
  ///   A FutureBuilder widget that displays the overdue section details.
  FutureBuilder<OverdueDetail?> _buildOverdueSection() {
    return FutureBuilder(
        future: _fetchOverdueDetail,
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
                            Text(
                              AppLocalizations.of(context)!.overdueDetailAmountLabel,
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: CommonUtil.colorTheme(context, darkColor: mDarkUnPaidColor, lightColor: mLightUnPaidColor),
                                  ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.priceFormatBaht(overdueDetail.amount),
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: CommonUtil.colorTheme(context, darkColor: mDarkUnPaidColor, lightColor: mLightUnPaidColor),
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.overdueDetailDueDateLabel, style: Theme.of(context).textTheme.bodyMedium),
                            Text(DateFormatterUtil.formatShortDate(context, overdueDetail.dueDate), style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                        if (overdueDetail.creditNumber?.isNotEmpty ?? false) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context)!.overdueDetailCreditNumberLabel, style: Theme.of(context).textTheme.bodyMedium),
                              Text(overdueDetail.creditNumber ?? '-', style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context)!.overdueDetailDebitDateLabel, style: Theme.of(context).textTheme.bodyMedium),
                              Text(DateFormatterUtil.formatShortDate(context, overdueDetail.debitDate, '-'), style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ],
                        FilledButton(
                            onPressed: () {
                              Navigator.pushNamed(context, PaymentChannelsView.routeName, arguments: {
                                'contract': _selectedContract,
                                'overdueDetail': overdueDetail,
                              });
                            },
                            child: Text(AppLocalizations.of(context)!.overdueDetailPayment)),
                        TextButton(
                            onPressed: () => Navigator.pushNamed(context, OverduesView.routeName, arguments: {'contract': _selectedContract!}),
                            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onSurface),
                            child: Text(AppLocalizations.of(context)!.overdueDetailViewDetail)),
                      ],
                    ),
                  ),
          );
        });
  }

  /// Builds a list of widgets representing payment histories.
  ///
  /// This method takes a [BuildContext] as a parameter and returns a list of
  /// [Widget] objects that display the payment histories.
  ///
  /// The payment histories are typically displayed in a user interface to
  /// provide a visual representation of past payments.
  ///
  /// [context] - The build context in which the widgets are built.
  ///
  /// Returns a list of [Widget] objects representing payment histories.
  List<Widget> _buildPaymentHistories(BuildContext context) {
    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: mDefaultPadding),
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
      FutureBuilder(
          future: context.read<ContractProvider>().fetchPaymentsByYear(_selectedContract!.contractId, _selectedYear),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SliverFillRemaining(child: Center(child: CircularProgressIndicator.adaptive()));
            }
            final payments = snapshot.data;
            return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return HistoryListTile(
                paymentDetail: payments![index],
                onTap: payments[index].status == 'รอยืนยันเงิน' ? null : () => _viewReceipt(payments[index].receiptNumber),
              );
            }, childCount: payments?.length));
          })
    ];
  }

  void _viewReceipt(String receiptNumber) {
    Navigator.pushNamed(context, ReceiptView.routeName, arguments: {
      'contractNumber': _selectedContract!.contractId,
      'receiptNumber': receiptNumber,
    });
  }
}
