import 'package:AssetWise/src/features/contract/contracts_view.dart';
import 'package:AssetWise/src/features/dashboard/widgets/campaign/campaign_pop.dart';
import 'package:AssetWise/src/features/dashboard/widgets/bottom_bar/bottom_bar.dart';
import 'package:AssetWise/src/features/dashboard/widgets/main/dashboard_main_view.dart';
import 'package:AssetWise/src/features/my_qr/my_qr_view.dart';
import 'package:AssetWise/src/features/profile/profile_view.dart';
import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:AssetWise/src/widgets/webview_with_close.dart';
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
  bool _isLoading = false;
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
                      if (tab == BottomTab.myqr) {
                        // Check if the user is authenticated before navigating to My QR page
                        Navigator.pushNamed(context, MyQrView.routeName);
                      } else if (tab == BottomTab.privilege) {
                        _openPriviledge();
                      } else if (tab == BottomTab.myUnit) {
                        _openMyUnit();
                      } else if (tab == BottomTab.profile) {
                        _openProfile();
                      } else {
                        setState(() {
                          _currentTab = tab;
                        });
                      }
                    },
                  ),
                ),
              );
            },
          ),
          const CampaignPop(),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  void _openPriviledge() async {
    setState(() {
      _isLoading = true;
    });
    final link = await context.read<UserProvider>().getPriviledgeLink();
    if (link == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.errorUnableToProcess),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebViewWithCloseButton(link: link)),
    );
    setState(() {
      _isLoading = false;
    });
  }

  void _openMyUnit() {
    Navigator.of(context).pushNamed(ContractsView.routeName);
  }

  void _openProfile() {
    Navigator.of(context).pushNamed(ProfileView.routeName);
  }
}
