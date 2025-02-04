import 'package:AssetWise/src/features/dashboard/profile_view.dart';
import 'package:AssetWise/src/features/dashboard/widgets/campaign/campaign_pop.dart';
import 'package:AssetWise/src/features/dashboard/widgets/bottom_bar/bottom_bar.dart';
import 'package:AssetWise/src/features/dashboard/widgets/main/main_view.dart';
import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key, required this.controller});
  final SettingsController controller;
  static const String routeName = '/dashboard';

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  BottomTab _currentTab = BottomTab.home;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AssetWiseBG(),
          if (_currentTab == BottomTab.home) const DashboardMainView(),
          if (_currentTab == BottomTab.profile) const ProfileView(),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom,
            child: SizedBox(
              height: 130,
              child: BottomBar(
                currentTab: _currentTab,
                normalFlex: 4,
                expandedFlex: 5,
                onTabChanged: (tab) {
                  setState(() {
                    _currentTab = tab;
                  });
                  switch (tab) {
                    case BottomTab.home:
                      break;
                    case BottomTab.service:
                      break;
                    case BottomTab.menu:
                      break;
                    case BottomTab.profile:
                      break;
                    default:
                      break;
                  }
                },
              ),
            ),
          ),
          const CampaignPop(),
        ],
      ),
    );
  }
}
