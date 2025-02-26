import 'package:AssetWise/src/features/dashboard/widgets/home_action_button/home_action_button.dart';
import 'package:AssetWise/src/features/dashboard/widgets/main/notification_section.dart';
import 'package:AssetWise/src/providers/dashboard_provider.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:flutter/material.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/widgets/aw_carousel.dart';
import 'package:AssetWise/src/features/dashboard/widgets/suggest_assets/suggest_asset.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DashboardMainView extends StatelessWidget {
  const DashboardMainView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.read<DashboardProvider>();
    // preload images
    for (final content in dashboardProvider.banners) {
      precacheImage(NetworkImage(content.image), context);
    }
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.top + 16.0),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue, vertical: mDefaultPadding / 4),
            child: const Row(
              children: [
                AssetWiseLogo(
                  width: 158,
                ),
                Spacer(),
                HomeActionButtons()
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
              child: AWCarousel(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                children: [
                  for (var imageContent in dashboardProvider.banners)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        image: DecorationImage(
                          image: NetworkImage(imageContent.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                ],
              )),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(left: mScreenEdgeInsetValue, right: mScreenEdgeInsetValue),
            child: DashboardNotificationSection(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue, vertical: mDefaultPadding),
            child: Text(
              AppLocalizations.of(context)!.dashboardMainSectionRecommended,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: mScreenEdgeInsetValue, right: mScreenEdgeInsetValue, bottom: mMediumPadding),
            child: Text(
              AppLocalizations.of(context)!.dashboardMainSectionRecommendedDetail,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        SuggestAssets(
          projects: dashboardProvider.suggestProjects,
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).padding.bottom + 84 + mDefaultPadding,
          ),
        )
      ],
    );
  }
}
