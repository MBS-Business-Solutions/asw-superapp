import 'package:AssetWise/src/providers/dashboard_provider.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:flutter/material.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/widgets/aw_carousel.dart';
import 'package:AssetWise/src/features/dashboard/widgets/suggest_assets/suggest_asset.dart';
import 'package:AssetWise/src/widgets/hot_menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DashboardMainView extends StatelessWidget {
  const DashboardMainView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.read<DashboardProvider>();
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.top + 16.0),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
            child: SizedBox(
              height: 48,
              child: Row(
                children: [
                  const AssetWiseLogo(
                    width: 129,
                  ),
                  const Spacer(),
                  _buildActionButtons()
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
        // SliverToBoxAdapter(
        //   child: Padding(
        //     padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0),
        //     child: _buildFavouriteMenus(context),
        //   ),
        // ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: mDefaultPadding),
            child: Text(
              AppLocalizations.of(context)!.sectionRecommended,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              AppLocalizations.of(context)!.sectionRecommendedDetail,
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

  Row _buildActionButtons() {
    return Row(
      children: [
        IconButton(onPressed: () {}, icon: Badge.count(count: 8, child: Icon(Icons.notifications_none))),
        IconButton(onPressed: () {}, icon: Icon(Icons.gite_sharp)),
      ],
    );
  }

  Widget _buildFavouriteMenus(BuildContext context) {
    // return SizedBox();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.sectionFavourite,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.sectionFavouriteMore),
                  Icon(
                    Icons.chevron_right,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HotMenuWidget(
              iconAsset: 'assets/icons/PriceCheckSharp.svg',
              titleText: 'ชำระค่างวด',
            ),
            HotMenuWidget(
              iconAsset: 'assets/icons/Campaign.svg',
              titleText: 'โปรโมชั่น',
            ),
            HotMenuWidget(
              iconAsset: 'assets/icons/hot_deal.svg',
              titleText: 'Hot Deal',
            ),
            HotMenuWidget(
              iconAsset: 'assets/icons/news.svg',
              titleText: 'ข่าวสาร',
            ),
            HotMenuWidget(
              iconAsset: 'assets/icons/questionaire.svg',
              titleText: 'สอบถาม',
            ),
          ],
        ),
      ],
    );
  }
}
