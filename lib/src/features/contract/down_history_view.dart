import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/features/contract/widgets/down_payment_tile.dart';
import 'package:AssetWise/src/models/aw_contract_model.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DownHistoryView extends StatelessWidget {
  const DownHistoryView({super.key, required this.contractId});
  static const String routeName = '/down-history';
  final String contractId;

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
          AppLocalizations.of(context)!.downHistoryViewTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? mDarkBackgroundColor : mLightBackgroundColor,
      ),
      body: FutureBuilder(
          future: context.read<ContractProvider>().fetchDownPayments(contractId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final terms = snapshot.data as List<DownPaymentDetail>;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return DownPaymentTile(
                      paymentDetail: terms[index],
                    );
                  },
                  itemCount: terms.length),
            );
          }),
    );
  }
}
