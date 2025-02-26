import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/features/profile/profile_view.dart';
import 'package:AssetWise/src/features/notifications/notifications_view.dart';
import 'package:AssetWise/src/features/register/register_view.dart';
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
                Navigator.of(context).pushNamed(RegisterView.routeName);
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
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(ContractsView.routeName);
                },
                icon: const Icon(Icons.gite_sharp)),
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
}
