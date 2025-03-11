import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/features/pin/pin_entry_view.dart';
import 'package:AssetWise/src/features/profile/profile_view.dart';
import 'package:AssetWise/src/features/notifications/notifications_view.dart';
import 'package:AssetWise/src/features/register/register_view.dart';
import 'package:AssetWise/src/providers/contract_provider.dart';
import 'package:AssetWise/src/providers/notification_item_provider.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeActionButtons extends StatelessWidget {
  const HomeActionButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (!(userProvider.isAuthenticated)) {
          return FilledButton(
              onPressed: () {
                _login(context);
              },
              child: const Icon(Icons.login));
        }
        return Row(
          children: [
            Consumer<NotificationItemProvider>(
              builder: (context, provider, child) => IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(NotificationsView.routeName);
                  },
                  icon: Badge.count(isLabelVisible: provider.unreadAllCount > 0, count: provider.unreadAllCount, child: const Icon(Icons.notifications_none))),
            ),
            FutureBuilder(
                future: context.read<ContractProvider>().fetchContracts(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  if (snapshot.data == null || (snapshot.data as List).isEmpty) {
                    return const SizedBox();
                  }
                  return IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(ContractsView.routeName);
                      },
                      icon: const Icon(Icons.gite_sharp));
                }),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(ProfileView.routeName);
                },
                icon: const Icon(Icons.person_outline_sharp)),
          ],
        );
      },
    );
  }

  void _login(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    final isPinSet = userProvider.isPinSet;
    if (isPinSet) {
      final isValidPin = await Navigator.of(context).pushNamed(PinEntryView.routeName, arguments: {'isBackable': true});
      if (isValidPin == true) {
        userProvider.reloginUsingPin();
      }
    } else {
      Navigator.of(context).pushNamed(RegisterView.routeName);
    }
  }
}
