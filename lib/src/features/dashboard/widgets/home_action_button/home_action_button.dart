import 'package:AssetWise/src/features/register/consents_view.dart';
import 'package:AssetWise/src/features/register/register_view.dart';
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
        if (!(userProvider.isAuthenticated))
          return FilledButton(
              onPressed: () {
                Navigator.of(context).pushNamed(RegisterView.routeName);
              },
              child: Icon(Icons.login));
        return Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(ConsentsView.routeName);
                },
                icon: Badge.count(count: 8, child: Icon(Icons.notifications_none))),
            IconButton(onPressed: () {}, icon: Icon(Icons.gite_sharp)),
          ],
        );
      },
    );
  }
}
