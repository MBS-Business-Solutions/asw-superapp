import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/features/my_assets/add_asset_view.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyAssetsView extends StatefulWidget {
  const MyAssetsView({super.key});
  static const String routeName = '/my-assets';

  @override
  State<MyAssetsView> createState() => _MyAssetsViewState();
}

class _MyAssetsViewState extends State<MyAssetsView> {
  int? _selectedIndex;
  late Future<List<Contract>?> _contractsFuture;
  @override
  void initState() {
    _contractsFuture = context.read<ContractProvider>().fetchContracts(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const AssetWiseBG(),
          Positioned.fill(
              child: FutureBuilder(
                  future: _contractsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final contracts = snapshot.data;
                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          backgroundColor: Colors.transparent,
                          centerTitle: true,
                          title: Text(AppLocalizations.of(context)!.myAssetTitle),
                          floating: true,
                          pinned: true,
                        ),
                        if (contracts?.isNotEmpty ?? false)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                              child: Text(AppLocalizations.of(context)!.myAssetSum(contracts?.length ?? 0), style: Theme.of(context).textTheme.labelLarge),
                            ),
                          ),
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final contract = contracts![index];
                            return MyAssetListTile(
                              onActionPressed: (contract) => _showContractActionBottomSheet(contract, index),
                              isSelected: _selectedIndex == index,
                              contract: contract,
                            );
                          },
                          childCount: contracts?.length,
                        )),
                        SliverToBoxAdapter(
                          child: SizedBox(height: MediaQuery.of(context).padding.bottom + 48),
                        ),
                      ],
                    );
                  })),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + mMediumPadding,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
              child: FilledButton.icon(onPressed: () => _addNewAsset(), icon: const Icon(Icons.add), label: Text(AppLocalizations.of(context)!.myAssetAdd)),
            ),
          ),
        ],
      ),
    );
  }

  void _addNewAsset() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAssetView()));

    _refreshData();
  }

  void _showContractActionBottomSheet(Contract contract, int? selectedIndex) async {
    setState(() {
      _selectedIndex = selectedIndex;
    });
    final action = await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: mScreenEdgeInsetValue, right: mScreenEdgeInsetValue, top: mScreenEdgeInsetValue),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: () => Navigator.pop(context, _MyAssetAction.viewDetail),
                    child: Text(AppLocalizations.of(context)!.myAssetViewDetail),
                  ),
                  const SizedBox(height: mDefaultPadding),
                  OutlinedButton(
                      onPressed: () => Navigator.pop(context, _MyAssetAction.setDefault),
                      child: Text(
                        AppLocalizations.of(context)!.myAssetSetDefault,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      )),
                  const SizedBox(height: mDefaultPadding),
                  if (!contract.isResident) ...[
                    OutlinedButton(
                        onPressed: () => Navigator.pop(context, _MyAssetAction.delete),
                        child: Text(
                          AppLocalizations.of(context)!.myAssetDelete,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                        )),
                    const SizedBox(height: mDefaultPadding),
                  ]
                ],
              ),
            ),
          );
        });
    switch (action) {
      case _MyAssetAction.viewDetail:
        _viewDetail(contract);
        break;
      case _MyAssetAction.setDefault:
        _setDefault(contract);
        break;
      case _MyAssetAction.delete:
        _showDeleteConfirmation(contract);
        break;
      default:
        break;
    }
    setState(() {
      _selectedIndex = null;
    });
  }

  void _viewDetail(Contract contract) {
    Navigator.pushNamed(context, ContractsView.routeName, arguments: {'linkId': contract.contractId});
  }

  void _setDefault(Contract contract) async {
    if (mounted) {
      final result = await context.read<ContractProvider>().setDefaultContract(contract.id);
      _refreshData();
      if (result) {
        Navigator.pushNamed(context, ContractsView.routeName, arguments: {'linkId': contract.contractId});
      }
    }
  }

  void _showDeleteConfirmation(Contract contract) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context)!.myAssetDeleteConfirmation, style: Theme.of(context).textTheme.labelLarge),
          content: Padding(
            padding: const EdgeInsets.only(top: mDefaultPadding),
            child: Text(AppLocalizations.of(context)!.myAssetDeleteDetail(contract.unitNumber), style: Theme.of(context).textTheme.bodyMedium),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                AppLocalizations.of(context)!.myAssetDeleteDelete,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(color: mRedColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                AppLocalizations.of(context)!.myAssetDeleteCancel,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          ],
        );
      },
    );
    if (result) {
      final response = await context.read<ContractProvider>().removeContract(contract.id);
      if (response != null) {
        final isSuccess = response.status == 'success';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          closeIconColor: Theme.of(context).colorScheme.onSurface,
          padding: EdgeInsets.zero,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: mDefaultPadding),
            child: Row(
              children: [
                Icon(
                  isSuccess ? Icons.check_circle : Icons.error,
                  color: isSuccess ? mGreenColor : mBrightRedColor,
                ),
                const SizedBox(width: mMediumPadding),
                Text(
                  isSuccess ? AppLocalizations.of(context)!.myAssetDeleteSuccess : response.message ?? '-',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              ],
            ),
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 100, right: 20, left: 20),
        ));
        _refreshData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          closeIconColor: Theme.of(context).colorScheme.onSurface,
          padding: EdgeInsets.zero,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: mDefaultPadding),
            child: Row(
              children: [
                const Icon(
                  Icons.error,
                  color: mRedColor,
                ),
                const SizedBox(width: mMediumPadding),
                Text(
                  AppLocalizations.of(context)!.errorUnableToProcess,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              ],
            ),
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 100, right: 20, left: 20),
        ));
      }
    }
  }

  void _refreshData() {
    setState(() {
      _contractsFuture = context.read<ContractProvider>().fetchContracts(context);
    });
  }
}

enum _MyAssetAction { viewDetail, setDefault, delete }

class MyAssetListTile extends StatelessWidget {
  const MyAssetListTile({
    super.key,
    required this.contract,
    this.onActionPressed,
    this.isSelected = false,
  });
  final Contract contract;
  final Function(Contract contract)? onActionPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onActionPressed?.call(contract);
        },
        child: ListTile(
          selected: isSelected,
          title: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(mSmallPadding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                      width: 64,
                      height: 64,
                      child: Image.network(
                        contract.imageUrl,
                        fit: BoxFit.cover,
                      )),
                ),
                const SizedBox(width: mMediumPadding),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(contract.unitNumber, style: Theme.of(context).textTheme.labelLarge!.copyWith(color: isSelected ? mBrightPrimaryColor : null))),
                    Expanded(child: Text(contract.projectName, style: Theme.of(context).textTheme.labelMedium!.copyWith(color: isSelected ? mBrightPrimaryColor : null))),
                    Expanded(
                      child: contract.isDefault
                          ? Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: CommonUtil.colorTheme(context, darkColor: mDarkPaidColor, lightColor: mLightPaidColor),
                                  size: 20,
                                ),
                                const SizedBox(width: mMediumPadding),
                                Text(
                                  AppLocalizations.of(context)!.myAssetDefault,
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        color: CommonUtil.colorTheme(context, darkColor: mDarkPaidColor, lightColor: mLightPaidColor),
                                      ),
                                )
                              ],
                            )
                          : const SizedBox(),
                    )
                  ],
                ),
              ],
            ),
          ),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
