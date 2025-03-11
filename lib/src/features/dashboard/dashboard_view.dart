import 'package:AssetWise/src/features/dashboard/widgets/campaign/campaign_pop.dart';
import 'package:AssetWise/src/features/dashboard/widgets/bottom_bar/bottom_bar.dart';
import 'package:AssetWise/src/features/dashboard/widgets/main/dashboard_main_view.dart';
import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          if (_currentTab == BottomTab.home)
            const DashboardMainView()
          else
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/images/ComingSoon.svg'),
                  const SizedBox(height: 20),
                  Text(AppLocalizations.of(context)!.errorComingSoon, style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
          Consumer<UserProvider>(
            builder: (context, provider, child) {
              if (!provider.isAuthenticated) {
                if (_currentTab != BottomTab.home) {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    setState(() {
                      _currentTab = BottomTab.home;
                    });
                  });
                }
                return const SizedBox();
              }

              return Positioned(
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
                        case BottomTab.calendar:
                          break;
                        default:
                          break;
                      }
                    },
                  ),
                ),
              );
            },
          ),
          const CampaignPop(),
        ],
      ),
    );
  }
}
