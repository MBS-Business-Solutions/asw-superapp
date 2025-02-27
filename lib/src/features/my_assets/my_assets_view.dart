import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/features/my_assets/add_asset_view.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAssetsView extends StatefulWidget {
  const MyAssetsView({super.key});
  static const String routeName = '/my-assets';

  @override
  State<MyAssetsView> createState() => _MyAssetsViewState();
}

class _MyAssetsViewState extends State<MyAssetsView> {
  late final Future<List<Contract>?> _contractsFuture;
  @override
  void initState() {
    _contractsFuture = context.read<ContractProvider>().fetchContracts();
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
                        const SliverAppBar(
                          backgroundColor: Colors.transparent,
                          centerTitle: true,
                          title: Text('บ้านของฉัน'),
                          floating: true,
                          pinned: true,
                        ),
                        if (contracts?.isNotEmpty ?? false)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                              child: Text('${contracts?.length} หลัง', style: Theme.of(context).textTheme.labelLarge),
                            ),
                          ),
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final contract = contracts![index];
                            return MyAssetListTile(
                              onActionPressed: (contract) => _showContractActionBottomSheet(contract),
                              contract: contract,
                            );
                          },
                          childCount: contracts?.length,
                        )),
                      ],
                    );
                  })),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + mMediumPadding,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
              child: FilledButton.icon(onPressed: () => _addNewAsset(), icon: const Icon(Icons.add), label: const Text('เพิ่มบ้าน')),
            ),
          ),
        ],
      ),
    );
  }

  void _addNewAsset() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAssetView()));
  }

  void _showContractActionBottomSheet(Contract contract) async {
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
                  FilledButton(onPressed: () => Navigator.pop(context, _MyAssetAction.viewDetail), child: const Text('ดูรายละเอียด')),
                  const SizedBox(height: mDefaultPadding),
                  OutlinedButton(
                      onPressed: () => Navigator.pop(context, _MyAssetAction.setDefault),
                      child: Text(
                        'ตั้งเป็นค่าเริ่มต้น',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      )),
                  const SizedBox(height: mDefaultPadding),
                  OutlinedButton(
                      onPressed: () => Navigator.pop(context, _MyAssetAction.delete),
                      child: Text(
                        'ลบบ้าน',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      )),
                  const SizedBox(height: mDefaultPadding),
                ],
              ),
            ),
          );
        });
    switch (action) {
      case _MyAssetAction.viewDetail:
        Navigator.pushNamed(context, ContractsView.routeName, arguments: {'linkId': contract.id});
        break;
      case _MyAssetAction.setDefault:
        break;
      case _MyAssetAction.delete:
        _showDeleteConfirmation(contract);
        break;
      default:
        break;
    }
  }

  void _showDeleteConfirmation(Contract contract) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('ต้องการลบบ้านใช่หรือไม่', style: Theme.of(context).textTheme.labelLarge),
          content: Padding(
            padding: const EdgeInsets.only(top: mDefaultPadding),
            child: Text('หากคุณทำการลบบ้านเลขที่ ${contract.unitNumber}\nข้อมูลทั้งหมดจะถูกลบออกจากระบบ', style: Theme.of(context).textTheme.bodyMedium),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                'ลบ',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(color: mRedColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                'ยกเลิก',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          ],
        );
      },
    );
    if (result) {
      // call API to delete contract

      const isDeleted = true;
      if (isDeleted) {
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
                  Icons.check_circle,
                  color: mGreenColor,
                ),
                const SizedBox(width: mMediumPadding),
                Text(
                  'ลบข้อมูลบ้านสำเร็จ',
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
}

enum _MyAssetAction { viewDetail, setDefault, delete }

class MyAssetListTile extends StatelessWidget {
  const MyAssetListTile({
    super.key,
    required this.contract,
    this.onActionPressed,
  });
  final Contract contract;
  final Function(Contract contract)? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onActionPressed?.call(contract);
        },
        child: ListTile(
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
                    Expanded(child: Text(contract.unitNumber, style: Theme.of(context).textTheme.labelLarge)),
                    Expanded(child: Text(contract.projectName, style: Theme.of(context).textTheme.labelMedium)),
                    Expanded(
                      child: contract.isDefault
                          ? Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: mPaidColor,
                                  size: 20,
                                ),
                                const SizedBox(width: mMediumPadding),
                                Text(
                                  'ค่าเริ่มต้น',
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: mPaidColor),
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
